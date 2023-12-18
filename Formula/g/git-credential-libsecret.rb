class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.43.0.tar.xz"
  sha256 "5446603e73d911781d259e565750dcd277a42836c8e392cac91cf137aa9b76ec"
  license "GPL-2.0-or-later"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7754b353f89366501fd68a0e2e39f8695a2eb0a8ec6e04026a229e48cea1ff55"
    sha256 cellar: :any,                 arm64_ventura:  "285c45c45221a1c91d8778f52747101c346c8c6de7122c7df47f221a679c387b"
    sha256 cellar: :any,                 arm64_monterey: "573ee1bf00752d3c1d2d940544702b08d30e376e08551cbf272cb0cddc2596b9"
    sha256 cellar: :any,                 sonoma:         "a1ffb42bb1d40de7d0e1216c22a6e3133e68c4343c5fe011c2ac6f1f2b1ff786"
    sha256 cellar: :any,                 ventura:        "7a6a1d4a8f2fb6d8c9ab86540905f8ca2266fbdffc7f67411b3cc1c97efed782"
    sha256 cellar: :any,                 monterey:       "127e516ad174bc38ac420679bd6c5574edbbbab3920f232f0462177bfe858499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb3e1be99562a92b6c1df74c4557d427a343b4ebf42c101f08f856115499cbd4"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsecret"

  def install
    cd "contribcredentiallibsecret" do
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
    assert_equal output, pipe_output("#{bin}git-credential-libsecret get", input, 1)
  end
end