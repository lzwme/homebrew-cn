cask "megacmd" do
  version "2.1.0"
  sha256 :no_check

  url "https:mega.nzMEGAcmdSetup.dmg"
  name "MEGAcmd"
  desc "Command-line access to MEGA services"
  homepage "https:mega.nzcmd"

  # The upstream website doesn't appear to provide version information. We check
  # GitHub tags as a best guess of when a new version is released (upstream
  # doesn't use GitHub releases).
  livecheck do
    url "https:github.commeganzMEGAcmd"
    regex(^v?(\d+(?:\.\d+)+)[._-]macOS$i)
  end

  depends_on macos: ">= :catalina"

  app "MEGAcmd.app"
  binary "#{appdir}MEGAcmd.appContentsMacOSMEGAcmdShell", target: "megacmd"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-attr"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-backup"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-cancel"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-cat"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-cd"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-cmd"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-confirm"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-confirmcancel"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-cp"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-debug"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-deleteversions"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-df"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-du"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-errorcode"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-exclude"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-exec"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-export"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-find"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-ftp"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-get"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-graphics"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-help"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-https"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-import"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-invite"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-ipc"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-killsession"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-lcd"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-log"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-login"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-logout"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-lpwd"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-ls"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-mediainfo"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-mkdir"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-mount"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-mv"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-passwd"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-permissions"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-preview"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-put"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-pwd"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-quit"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-reload"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-rm"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-session"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-share"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-showpcr"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-signup"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-speedlimit"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-sync"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-thumbnail"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-transfers"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-tree"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-userattr"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-users"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-version"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-webdav"
  binary "#{appdir}MEGAcmd.appContentsMacOSmega-whoami"

  zap trash: "~.megaCmd"

  caveats <<~EOS
    #{token} only works if called from Applications, so you may need to install
    it with:

      brew install --cask --appdir=Applications #{token}
  EOS
end