{ Pointers to basic pascal types, inserted by h2pas conversion program.}
Type
  PLongint  = ^Longint;
  PSmallInt = ^SmallInt;
  PByte     = ^Byte;
  PWord     = ^Word;
  PDWord    = ^DWord;
  PDouble   = ^Double;

{$PACKRECORDS C}

{ GTK - The GIMP Toolkit
   Copyright (C) 2001 Red Hat, Inc.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the
   Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.
  }
{
   Authors: Alexander Larsson <alexl@redhat.com>
  }

procedure gtk_decorated_window_init(window:PGtkWindow); cdecl; external gtklib;
procedure gtk_decorated_window_calculate_frame_size(window:PGtkWindow); cdecl; external gtklib;

procedure gtk_decorated_window_set_title(window:PGtkWindow; title:Pgchar); cdecl; external gtklib;
procedure gtk_decorated_window_move_resize_window(window:PGtkWindow; x:gint; y:gint; width:gint; height:gint); cdecl; external gtklib;

