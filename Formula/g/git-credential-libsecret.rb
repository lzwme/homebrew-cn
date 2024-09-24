class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.46.2.tar.xz"
  sha256 "5ee8a1c68536094a4f7f9515edc154b12a275b8a57dda4c21ecfbf1afbae2ca3"
  license "GPL-2.0-or-later"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "967b71e4d74639c54def7a32b295add6726d455296b03af9a3b986c9bc500d7e"
    sha256 cellar: :any,                 arm64_sonoma:  "4b40ff5b85b56472fa41bd18812fc1783a8a6fee349251131ea1d9b6ef62d662"
    sha256 cellar: :any,                 arm64_ventura: "5fda3e70001e0a02c08b03a63298018b8e655dacc4b2580132a987bf8d373032"
    sha256 cellar: :any,                 sonoma:        "de74e36b8e71980ddd17239eb55f2a95d0aeba692cb35fd1e0327b2cecd54ab1"
    sha256 cellar: :any,                 ventura:       "6db09cdd3dbda27cda1f5f6efbb559dc06d0e82d42de46cd986cfa55623b7810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68263d29359e7bc23b038bd45f2d41c3ee1902b862db20db157e511d13864967"
  end

  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "libsecret"

  on_macos do
    depends_on "gettext"
  end

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