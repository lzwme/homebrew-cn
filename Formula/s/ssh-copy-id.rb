class SshCopyId < Formula
  desc "Add a public key to a remote machine's authorized_keys file"
  homepage "https:www.openssh.com"
  url "https:cdn.openbsd.orgpubOpenBSDOpenSSHportableopenssh-9.7p1.tar.gz"
  mirror "https:cloudflare.cdn.openbsd.orgpubOpenBSDOpenSSHportableopenssh-9.7p1.tar.gz"
  version "9.7p1"
  sha256 "490426f766d82a2763fcacd8d83ea3d70798750c7bd2aff2e57dc5660f773ffd"
  license "SSH-OpenSSH"
  head "https:github.comopensshopenssh-portable.git", branch: "master"

  livecheck do
    formula "openssh"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "462f07572c6a54fb77fd91e5da31f904f6d1c7a9bb1816ef84a43c5f95bede7c"
  end

  keg_only :provided_by_macos

  def install
    bin.install "contribssh-copy-id"
    man1.install "contribssh-copy-id.1"
  end

  test do
    output = shell_output("#{bin}ssh-copy-id -h 2>&1", 1)
    assert_match "identity_file", output
  end
end