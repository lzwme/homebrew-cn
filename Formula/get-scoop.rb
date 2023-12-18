class GetScoop < Formula
  desc "Installer for scoop Windows command-line portable tools installer"
  homepage "https:github.comnicerloopScoopInstalltreemacos"
  head "https:github.comnicerloopScoopInstall.git", branch: "macos"

  livecheck do
    skip "head-only formula"
  end

  depends_on "coreutils"
  depends_on "icoutils"
  depends_on "msitools"

  def install
    libexec.install Dir["*"]
    bin.join("get-scoop").write <<~SH
      #!binsh
      pwsh "#{prefix}libexecinstall.ps1" "$@"
    SH
  end

  def caveats
    <<~EOS
      get-scoop requires powershell and wine casks:
       brew install powershell wine
    EOS
  end
end