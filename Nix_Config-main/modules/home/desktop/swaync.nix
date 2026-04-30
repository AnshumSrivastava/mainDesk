{ config, pkgs, ... }:

{
  services.swaync = {
    enable = true;
    style = ''
      @define-color bg-base rgba(24, 24, 37, 0.7);
      @define-color bg-surface0 rgba(30, 30, 46, 0.8);
      @define-color text rgba(205, 214, 244, 1.0);
      @define-color text-muted rgba(205, 214, 244, 0.6);
      @define-color text-subtext rgba(205, 214, 244, 0.8);
      @define-color border rgba(255, 255, 255, 0.06);
      @define-color action-hover rgba(255, 255, 255, 0.08);

      * {
        font-family: 'Inter', sans-serif;
        font-weight: 500;
      }

      window,
      window#swaync-notification-window,
      window#swaync-control-center,
      .blank-window,
      .floating-notifications,
      .control-center-list,
      .control-center-list-pushed,
      .notification-vbox,
      .widget-title,
      .widget-dnd,
      .widget-mpris,
      .widget-menubar,
      .widget-buttons,
      .widget-volume,
      .widget-backlight,
      .widget-inhibitors {
        background-color: transparent !important;
        background: transparent !important;
        box-shadow: none !important;
      }

      .control-center .notification-row:focus,
      .control-center .notification-row:hover {
        opacity: 1;
        background: transparent;
      }

      .notification-row {
        outline: none;
        margin: 4px;
        padding: 0;
      }

      .notification {
        background: @bg-base;
        border: 1px solid @border;
        border-radius: 12px;
        margin: 0px;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
        padding: 12px;
        min-width: 300px;
        max-width: 350px;
      }

      .notification-content {
        background: transparent;
        padding: 0;
        border-radius: 10px;
      }

      .close-button {
        background: rgba(255, 255, 255, 0.05);
        color: @text;
        text-shadow: none;
        padding: 0;
        border-radius: 100%;
        margin-top: 6px;
        margin-right: 6px;
        min-width: 20px;
        min-height: 20px;
      }

      .close-button:hover {
        box-shadow: none;
        background: rgba(255, 255, 255, 0.15);
        transition: all 0.15s ease-in-out;
        border: none;
      }

      .notification-default-action,
      .notification-action {
        padding: 4px;
        margin: 0;
        box-shadow: none;
        background: transparent;
        border: 1px solid @border;
        color: @text;
        border-radius: 8px;
      }

      .notification-default-action:hover,
      .notification-action:hover {
        background: @action-hover;
      }

      .summary {
        font-size: 13px;
        font-weight: 600;
        background: transparent;
        color: #ffffff;
        text-shadow: none;
      }

      .time {
        font-size: 10px;
        font-weight: 500;
        background: transparent;
        color: @text-muted;
        text-shadow: none;
        margin-right: 20px; /* Space for close button */
      }

      .body {
        font-size: 12px;
        font-weight: 400;
        background: transparent;
        color: @text-subtext;
        text-shadow: none;
        margin-top: 2px;
      }

      .app-icon {
        border-radius: 6px;
        margin-right: 18px;
      }

      .app-name {
        font-size: 10px;
        color: rgba(255, 255, 255, 0.4);
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 2px;
      }
      
      /* Control Center specific */
      .control-center {
        background: @bg-base;
        border: 1px solid @border;
        border-radius: 16px;
        margin: 12px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
        min-width: 320px;
        max-width: 380px;
      }
      
      .widget-title {
        color: white;
        margin: 16px;
        font-size: 20px;
        font-weight: 600;
      }
      .widget-title > button {
        font-size: 14px;
        color: @text;
        text-shadow: none;
        background: rgba(255,255,255, 0.05);
        border: 1px solid @border;
        border-radius: 8px;
      }
      .widget-title > button:hover {
        background: @action-hover;
      }
    '';
    settings = {
      positionX = "center";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "overlay";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 16;
      control-center-margin-bottom = 16;
      control-center-margin-right = 16;
      control-center-margin-left = 16;
      notification-2way-close = true;
      notification-drop-shadow = false;
      image-visibility = "when-available";
      image-size = 36;
      transition-length = 200;
      hide-on-clear = true;
      hide-on-action = true;
      script-fail-notify = true;
      widgets = [
        "title"
        "dnd"
        "notifications"
      ];
      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
      };
    };
  };
}
