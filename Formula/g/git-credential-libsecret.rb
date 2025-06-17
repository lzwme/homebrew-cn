class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.50.0.tar.xz"
  sha256 "dff3c000e400ace3a63b8a6f8b3b76b88ecfdffd4504a04aba4248372cdec045"
  license "GPL-2.0-or-later"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e292942e42ea3264f27388a461dc29d11ac3c592b3b8f9051acdb7c78f5a4ac"
    sha256 cellar: :any,                 arm64_sonoma:  "84a53b0424434bcfbc78e45cbd86e040bea9972d6c1f8d243fc59d4f30cbb445"
    sha256 cellar: :any,                 arm64_ventura: "0706a3a6f30ab306e471bad0d753660f5185353551e05af9eb6a32fb2ac3004f"
    sha256 cellar: :any,                 sonoma:        "5a0862fff54f1aa93d010f0e3abb63bba04c2cbaedd961330c2e2353cdbb7942"
    sha256 cellar: :any,                 ventura:       "74e76430d2e4ffff10fec99af3972f003fff2143d4d2f2925724eca020af1a84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08f8448d0515a6312149b1c89bd376b369ff3e8ec3adc70647f3db8810c4055e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebbe2810b34fa074fb4e4ae0e61e753b464f355a81b212ad12d525849ede85b7"
  end

  depends_on "pkgconf" => :build

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