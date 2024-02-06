class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https:stacked-git.github.io"
  url "https:github.comstacked-gitstgitreleasesdownloadv2.4.3stgit-2.4.3.tar.gz"
  sha256 "4a749fb6c521764523c8a2f583c6f0123b060c589133696615d5588d43be5027"
  license "GPL-2.0-only"
  head "https:github.comstacked-gitstgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60d0a32be0c78d0cc9ac948dbfabe28c7eda788190d4784a452a3e89115f0439"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8a4dc22af75ae3780d0d88bc950cfcff458dc5fb4aaf407896e6ce8ffaaeffb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bf1b38d110bda8837aa33d12313601ae9d40d191e99f5f8a6a090f8aa24b733"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a00a224f49c4f0df946e4636c33aad8c1ed7bfd59a0e366899ebced8b2e5fb5"
    sha256 cellar: :any_skip_relocation, ventura:        "e904b3244269948ac37a7858e6af9ef869d17bad7160a7b21c0d4960b84a1711"
    sha256 cellar: :any_skip_relocation, monterey:       "6c68dfc3fe5cb21e03be024c4a1cc5d3218493977d5c93d666dc9764ec0a2f70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70c3b3d7288bf2c57a997f1031b582e8b62697cd1824f37e79a7d142c47af878"
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