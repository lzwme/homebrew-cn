class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.51.2.tar.xz"
  sha256 "233d7143a2d58e60755eee9b76f559ec73ea2b3c297f5b503162ace95966b4e3"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "50df611ae1b4964bd309976f1acf2c7d0e85062bf7e8c0e684482959c7e91b8b"
    sha256 cellar: :any,                 arm64_sequoia: "9ecac7e3a2880cd533d07993ccdd3bf95b186537695c24f44e922faeff90b885"
    sha256 cellar: :any,                 arm64_sonoma:  "6cc6f15f7969e7d0c00bc895adbbd048f7f6b52715efd8e5823e227b9d0b7c34"
    sha256 cellar: :any,                 sonoma:        "301862baf7089a5f345bd8501c0cbee8827ff455513e3f77136f5304ab6aa4ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8adbe83ae7ed2c804b2f54cfed8a3d8d53279d731ea409c6c7fcd7bff6de953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0746be57a6d79663a44558ea38f373c6fe8796a1fde20ed259172c5ef50ec96"
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