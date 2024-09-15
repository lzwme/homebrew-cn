class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.46.1.tar.xz"
  sha256 "888cafb8bd6ab4cbbebc168040a8850eb088f81dc3ac2617195cfc0877f0f543"
  license "GPL-2.0-or-later"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4caa002df40bbd0efb016835a71bc9e64dd7c8475369143d9aa08964c883ddf8"
    sha256 cellar: :any,                 arm64_sonoma:  "2a8e1b93ffa8ae3cb78b9941dc436497c19177d103c80d7d034bf801e63145ea"
    sha256 cellar: :any,                 arm64_ventura: "d388a5ab8d2beb652af7393871d4baf6ab001ff01df385cac00331e33bad4ce6"
    sha256 cellar: :any,                 sonoma:        "4463555119271dfcba9c43029108a6d2595176d767abe707203fe6fe8a6f32e7"
    sha256 cellar: :any,                 ventura:       "96ae52e38bd0524ae122c0ee7cf2a2a59e7dd2dd1096587d4cdc1e5951a0e005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6653f84163343867251f7829863a295f0c410a2bc2ffe513320f6ef23fd21513"
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