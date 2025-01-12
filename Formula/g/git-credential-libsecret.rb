class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.48.0.tar.xz"
  sha256 "4803b809c42696b3b8cce6b0ba6de26febe1197f853daf930a484db93c1ad0d5"
  license "GPL-2.0-or-later"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "abbe47e64c18d5296a4e43508ffaab595b6843ae91f2374cd98b177f44f5600e"
    sha256 cellar: :any,                 arm64_sonoma:  "7b4390fe161cd77b04feeda185d38f135f7e8b7274392a10b289316382c44b4e"
    sha256 cellar: :any,                 arm64_ventura: "ecdab6afdb54d0ed58cc6e1793b23e7c5a6ab59a7b5dd958cb04e7343f40545f"
    sha256 cellar: :any,                 sonoma:        "6510533b00bbe47783cf7d4e161b9127b2021e6fbc25716e0a87b42d5c071f19"
    sha256 cellar: :any,                 ventura:       "a3d5e8c3241f8e360c382f047194bc171d92408dd2060055e08dd8026e107fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33a7a12eb9fa87714e1b557f03a7f7972f7229ff8b80b064eec39623dac64c94"
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