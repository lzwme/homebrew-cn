class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.43.1.tar.xz"
  sha256 "2234f37b453ff8e4672c21ad40d41cc7393c9a8dcdfe640bec7ac5b5358f30d2"
  license "GPL-2.0-or-later"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "df2f7c6c66ef90950452ed720f4964b1608fb565ba19ce05fd01e9086ef5a251"
    sha256 cellar: :any,                 arm64_ventura:  "295a9b1a6959b4ba9e43129e37b45be617ea78510eaa05baf67bc34fa57a3dd8"
    sha256 cellar: :any,                 arm64_monterey: "4d30197fe17cf4fdc50261a9b5453c200db7d1e606bf2276cf3ff016301e02a4"
    sha256 cellar: :any,                 sonoma:         "481ae7b5aea01c931efbf8b0bd77782fcff1f3b7d1796e23d3f41c13a4dfe8c3"
    sha256 cellar: :any,                 ventura:        "c4b96e769bcbbcac7fd0e4ed254c94c62d39a85d143ec04a696458cf8e8f9ef2"
    sha256 cellar: :any,                 monterey:       "6a9f23731ec642464c58503872a591551922569841babd64f568ab51243de6bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3101708b269fbdb92219c50dce65d2c4bd9775c63864ca6dfa2e528b5641aae4"
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