class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.42.1.tar.xz"
  sha256 "8e46fa96bf35a65625d85fde50391e39bc0620d1bb39afb70b96c4a237a1a4f7"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "90fa35c54e852b130df3a1c5472de14cc83abcdf623647742084154aea5a3301"
    sha256 cellar: :any,                 arm64_ventura:  "20cec6e08414f7b35e71ffbbe1596a9c043ba6df372169de75af4bae54d7f528"
    sha256 cellar: :any,                 arm64_monterey: "8537fe8815cb1c684faacc7c9440c532c66bf51c81d3d6dc0a4d76e2b4954425"
    sha256 cellar: :any,                 sonoma:         "3e5d9c27b86ab3a5c820102e4ad0a4f10e27f71377d78271412cd0e411476be6"
    sha256 cellar: :any,                 ventura:        "ef1e7a81ea7d865f6a392b1236bf451c7e9d1b75527730d6b13c4053d595f147"
    sha256 cellar: :any,                 monterey:       "24e34039927692d6a5cdcaa70d7cc8b205a8b83e1e60ad6ac37a1004446c59b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95b074cba70213c533028e0f8d6257d8865a1fe1a3270ba6fdb41965abe25c75"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsecret"

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