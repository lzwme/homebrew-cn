class Scoop < Formula
  desc "Command-line installer for Windows"
  homepage "https://github.com/ScoopInstaller/Scoop"
  head "https://github.com/nicerloop/Scoop.git", branch: "macos"

  livecheck do
    skip "head-only formula"
  end

  depends_on "coreutils"
  depends_on "icoutils"
  depends_on "imagemagick"
  depends_on "msitools"

  def install
    inreplace "bin/scoop.ps1", "CHANGELOG.md", "..\\CHANGELOG.md"
    libexec.install Dir["*"]
    bin.join("scoop").write <<~SH
      #!/bin/sh
      pwsh "#{prefix}/libexec/bin/scoop.ps1" "$@"
    SH
  end

  def caveats
    <<~EOS
      get-scoop requires powershell and wine casks:
       brew install powershell wine-stable
    EOS
  end
end