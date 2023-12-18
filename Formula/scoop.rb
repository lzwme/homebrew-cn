class Scoop < Formula
  desc "Command-line installer for Windows"
  homepage "https:github.comScoopInstallerScoop"
  head "https:github.comnicerloopScoop.git", branch: "macos"

  livecheck do
    skip "head-only formula"
  end

  depends_on "coreutils"
  depends_on "icoutils"
  depends_on "imagemagick"
  depends_on "msitools"

  def install
    inreplace "binscoop.ps1", "CHANGELOG.md", "..\\CHANGELOG.md"
    libexec.install Dir["*"]
    bin.join("scoop").write <<~SH
      #!binsh
      pwsh "#{prefix}libexecbinscoop.ps1" "$@"
    SH
  end

  def caveats
    <<~EOS
      get-scoop requires powershell and wine casks:
       brew install powershell wine-stable
    EOS
  end
end