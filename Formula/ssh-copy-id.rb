class SshCopyId < Formula
  desc "Add a public key to a remote machine's authorized_keys file"
  homepage "https://www.openssh.com/"
  url "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.3p2.tar.gz"
  mirror "https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.3p2.tar.gz"
  version "9.3p2"
  sha256 "200ebe147f6cb3f101fd0cdf9e02442af7ddca298dffd9f456878e7ccac676e8"
  license "SSH-OpenSSH"
  head "https://github.com/openssh/openssh-portable.git", branch: "master"

  livecheck do
    formula "openssh"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60a7ec7c0f14767470994a0db0fc9659378b26023501c55ec1023855e8adf510"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60a7ec7c0f14767470994a0db0fc9659378b26023501c55ec1023855e8adf510"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60a7ec7c0f14767470994a0db0fc9659378b26023501c55ec1023855e8adf510"
    sha256 cellar: :any_skip_relocation, ventura:        "60a7ec7c0f14767470994a0db0fc9659378b26023501c55ec1023855e8adf510"
    sha256 cellar: :any_skip_relocation, monterey:       "60a7ec7c0f14767470994a0db0fc9659378b26023501c55ec1023855e8adf510"
    sha256 cellar: :any_skip_relocation, big_sur:        "60a7ec7c0f14767470994a0db0fc9659378b26023501c55ec1023855e8adf510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec6084b543f1df21a8bf3879dee06a4d382c572d76cd9ac7db9ee4fe11133bcf"
  end

  keg_only :provided_by_macos

  def install
    bin.install "contrib/ssh-copy-id"
    man1.install "contrib/ssh-copy-id.1"
  end

  test do
    output = shell_output("#{bin}/ssh-copy-id -h 2>&1", 1)
    assert_match "identity_file", output
  end
end