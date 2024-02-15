cask "prince" do
  version "15.3"
  sha256 "c1eacd1eec884ed7742674cc38446cf695745b885b59ce08eebd9abd9514bc24"

  url "https:www.princexml.comdownloadprince-#{version}-macos.zip"
  name "Prince"
  desc "Convert HTML to PDF"
  homepage "https:www.princexml.com"

  livecheck do
    url "https:www.princexml.comdownload"
    regex(>Prince v?(\d+(?:\.\d+)+)i)
  end

  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}prince-#{version}-macosprince.wrapper.sh"
  binary shimscript, target: "prince"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{staged_path}prince-#{version}-macoslibprincebinprince' --prefix '#{staged_path}prince-#{version}-macoslibprince' "$@"
    EOS
  end

  # No zap stanza required
end