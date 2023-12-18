class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https:stacked-git.github.io"
  url "https:github.comstacked-gitstgitreleasesdownloadv2.4.1stgit-2.4.1.tar.gz"
  sha256 "254ac8894df32deebe2daf5009fda7da4122208f215c3edb75b43b9d13f5581d"
  license "GPL-2.0-only"
  head "https:github.comstacked-gitstgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d302425e3a9aa513b0b5972020eaf43ed7093b3d0c1cce138117e9847f1427f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aebacb1f8be70308e416f00d8cd98242d5b4ed800c743ee2ac82da008ed969c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e110acc17410c472fb872d290c906175001537821ba52feca48b698026c6ee5"
    sha256 cellar: :any_skip_relocation, sonoma:         "12c06723871295252c5d42b45adda286f7916cf7cfb30d51ae3eeaf6f871ccb2"
    sha256 cellar: :any_skip_relocation, ventura:        "271852da7014af15af720f86c3a276a0fbf621c76272a974d24457cd85a8e3d8"
    sha256 cellar: :any_skip_relocation, monterey:       "c19079f92004a590de71b7abb8b9839471e8f3f1fd4357a81fcc0781c5e93162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d97b0e892c3f6bd31ee792967f4ab7765e5ccf6ef3a8768fe27cfdf8c7d2e013"
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