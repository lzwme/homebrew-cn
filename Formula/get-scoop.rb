class GetScoop < Formula
  desc "Installer for scoop Windows command-line portable tools installer"
  homepage "https://github.com/nicerloop/ScoopInstall/tree/macos"
  url "https://ghproxy.com/https://github.com/nicerloop/ScoopInstall/archive/56d79596b61fc2f7f52dc30d1900bfa11de08cd2.tar.gz"
  version "2023-10-04"
  sha256 "8399ec49fab042c5c922396a4ec60ed991bf3d5214597398d566de420fa4692f"
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