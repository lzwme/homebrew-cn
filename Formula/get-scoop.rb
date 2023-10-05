class GetScoop < Formula
  desc "Installer for scoop Windows command-line portable tools installer"
  homepage "https://github.com/nicerloop/ScoopInstall/tree/macos"
  head "https://github.com/nicerloop/ScoopInstall.git", branch: "macos"

  depends_on "coreutils"
  depends_on "icoutils"
  depends_on "msitools"

  def install
    libexec.install Dir["*"]
    bin.join("get-scoop").write <<~SH
      #!/bin/sh
      pwsh "#{prefix}/libexec/install.ps1" "$@"
    SH
  end

  def caveats
    <<~EOS
      get-scoop requires powershell and wine casks:
       brew install powershell wine
    EOS
  end
end