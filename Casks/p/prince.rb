cask "prince" do
  version "15.2"
  sha256 "b1584d25c89cecb07b668618c2c87a25e9ba39c1dd2d685b6ead9086e4401c1c"

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