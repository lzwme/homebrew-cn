class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.45.1.tar.xz"
  sha256 "e64d340a8e627ae22cfb8bcc651cca0b497cf1e9fdf523735544ff4a732f12bf"
  license "GPL-2.0-or-later"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1bd754acc0d146cb6dd8fb07171bbda45a3557994ce2ff474ec8d4d915e0beb1"
    sha256 cellar: :any,                 arm64_ventura:  "3c20c092ebbaa0099dd8c24fe8dc32eb6a3da44bc79bc236d64b4997f9a8a86c"
    sha256 cellar: :any,                 arm64_monterey: "74ae2e2ec776787b418312502a4a341f777ee5fbbf62c7966a2c6be1e6e06bf9"
    sha256 cellar: :any,                 sonoma:         "67164daf74e65b3abb3994ba60a047c0512b8b79e3aa1e6dd0ff643d262325ff"
    sha256 cellar: :any,                 ventura:        "f45a146dd08b94e0092fd04765a1eff98d4ccc22ca6056f9b19312f82d27b893"
    sha256 cellar: :any,                 monterey:       "de59178e6e089776ccca3f01e8b3dd55617d862bbac24864e93f41dbfc3ccd9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3243b2f631c13551dc15fdfac373993948a2b342ea860960344fb743308cadaa"
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