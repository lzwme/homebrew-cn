class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.51.1.tar.xz"
  sha256 "a83fd9ffaed7eee679ed92ceb06f75b4615ebf66d3ac4fbdbfbc9567dc533f4a"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "257541a5e20f2952a0f5c61024a8789b5fb28127caa88bca6cec8160d31f9719"
    sha256 cellar: :any,                 arm64_sequoia: "c495d9a9bbcfe6f159764143c8fff515db0606797e0d4189263fb4e7320c168c"
    sha256 cellar: :any,                 arm64_sonoma:  "195ba3dc4a7ba1e65ddb6976955d226448e7d040791598a001fd434943f1c460"
    sha256 cellar: :any,                 sonoma:        "e4fe4d5c5b7d8e928b738125d6a15ea2c323fa6c96f666aadd045614c936ba91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d718ec2de6fceeba1ab844b660fd22ba761aefed218aa300082187f15cd9e53e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "143ac0d12c422be9448c277e6bcc058d023889418a7985a54ac93d1bd0fb49c8"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libsecret"

  on_macos do
    depends_on "gettext"
  end

  def install
    cd "contrib/credential/libsecret" do
      system "make"
      bin.install "git-credential-libsecret"
    end
  end

  test do
    input = <<~EOS
      protocol=https
      username=Homebrew
      password=123
    EOS

    output = <<~EOS
      username=Homebrew
      password=123
    EOS

    assert_equal output, pipe_output("#{bin}/git-credential-libsecret get", input, 1)
  end
end