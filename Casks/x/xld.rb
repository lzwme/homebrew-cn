cask "xld" do
  version "20250302"
  sha256 "0032a5470ea4e32a11a35b8077ebf4986102891f8eb82743094f2c6621ad8aeb"

  url "https://downloads.sourceforge.net/xld/xld-#{version}.dmg",
      verified: "sourceforge.net/xld/"
  name "X Lossless Decoder"
  name "XLD"
  desc "Lossless audio decoder"
  homepage "https://tmkk.undo.jp/xld/index_e.html"

  livecheck do
    url "https://svn.code.sf.net/p/xld/code/appcast/xld-appcast_e.xml"
    strategy :sparkle, &:short_version
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  auto_updates true

  app "XLD.app"
  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/xld.wrapper.sh"
  binary shimscript, target: "xld"

  preflight do
    File.write shimscript, <<~EOS
      #!/bin/sh
      exec '#{appdir}/XLD.app/Contents/MacOS/XLD' "--cmdline" "$@"
    EOS
  end

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/jp.tmkk.xld.sfl*",
    "~/Library/Application Support/XLD",
    "~/Library/Caches/jp.tmkk.XLD",
    "~/Library/HTTPStorages/jp.tmkk.XLD",
    "~/Library/Preferences/jp.tmkk.XLD.plist",
    "~/Library/Saved Application State/jp.tmkk.XLD.savedState",
  ]
end