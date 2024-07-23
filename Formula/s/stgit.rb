class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https:stacked-git.github.io"
  url "https:github.comstacked-gitstgitreleasesdownloadv2.4.8stgit-2.4.8.tar.gz"
  sha256 "0088ba94ce3330ab2a28dd68f7c14062e30349b772c44398cc776d616991bd3c"
  license "GPL-2.0-only"
  head "https:github.comstacked-gitstgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02153bbb49b18456e0cc29cb5ed4cc87793252c2ba80e777b66f401dbb5e680b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "577d69c02ee6b94bad00e7bfbfd23674e76b376770371cbd9174bc8c2ffff290"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c73ed108c0dc437863d8c9de978b0d861628fe80fb87a15f5abd85be2ea82646"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c2f6bd532cf4fb083bf7816852c6d8df5302bea3470993f5982e81fdb4c9486"
    sha256 cellar: :any_skip_relocation, ventura:        "24baf79ef9a90a32f445050abdc37a24b0aa71e43f72b816504bbb80dad6b61e"
    sha256 cellar: :any_skip_relocation, monterey:       "96017b373d9cb61a693dbd3ba170d99a21ea2c94873c3ef0151a89fac818dfe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "768c415fb7cc039a6a3e6f9300c08bd0abf4dbcee618ef52fe728bb5e0220978"
  end

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "xmlto" => :build
  depends_on "git"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV["XML_CATALOG_FILES"] = etc"xmlcatalog"
    system "make", "prefix=#{prefix}", "install-bin", "install-man"
    system "make", "prefix=#{prefix}", "-C", "contribvim", "install"
    generate_completions_from_executable(bin"stg", "completion")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    (testpath"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}stg", "--version"
    system "#{bin}stg", "init"
    system "#{bin}stg", "new", "-m", "patch0"
    (testpath"test").append_lines "a change"
    system "#{bin}stg", "refresh"
    system "#{bin}stg", "log"
    system "man", "#{man}man1stg.1"
  end
end