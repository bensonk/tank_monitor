#!/usr/bin/python
import wx, sys, threading

status = [False, True, False, True]

class DisplayPanel(wx.Panel):
  def __init__(self, parent):
    super(DisplayPanel, self).__init__(parent, wx.ID_ANY)
    self.SetSizeHints(1280,1024)
    self.Bind(wx.EVT_PAINT, self.OnPaint)

    self._pen = wx.Pen("#305070")
    self._brush = wx.Brush("#305070")
    self._background = wx.Brush("WHITE")

  def OnPaint(self, event):
    dc = wx.AutoBufferedPaintDC(self)
    dc.SetBackground(self._background)
    dc.SetPen(self._pen)
    dc.SetBrush(self._brush)
    dc.Clear()
    self.DrawStatus(dc)

  def DrawStatus(self, dc):
    width, height = 200, 200
    coords = [ (0, 200*i) for i in range(3, -1, -1) ]
    for i in range(4):
      x, y = coords[i]
      if(status[i]):
        dc.DrawRectangle(x, y, width, height)


app = wx.App()
frame = wx.Frame(None, wx.ID_ANY, "Water Level", size=wx.Size(200, 800))
display = DisplayPanel(frame)
frame.Layout()

def listen_for_input():
  global status
  while(True):
    c = ord(sys.stdin.read(1))
    if(c >= ord('`')):
      status = map(bool, (1&c, 2&c, 4&c, 8&c))
      display.Refresh()
      print status

listening_thread = threading.Thread(target=listen_for_input)
listening_thread.daemon = True
listening_thread.start()



frame.Show(True)
app.MainLoop()
