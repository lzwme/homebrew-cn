class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https:stacked-git.github.io"
  url "https:github.comstacked-gitstgitreleasesdownloadv2.4.9stgit-2.4.9.tar.gz"
  sha256 "39e82063981eaec55fb225e891dc1a8125b08cbff4105b67aa3fe0e4f66f8d75"
  license "GPL-2.0-only"
  head "https:github.comstacked-gitstgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee6d3e921036e3b8ec0ddc654c8873bc75cbd56533ac4481c12e856769e3f745"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfcca557528cbb8346755c4847d6be03fc15853150fa2778b71d2d8fba1f429d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "392d9b44dea03bceec6b14267c0bd4f9ca4263a05151c70169b308c646e7013a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a063ae8f51a70e91aa7925fda9c39b24bc9aa41a995b021b0ff0c81b1fd3b5c"
    sha256 cellar: :any_skip_relocation, ventura:        "3e733499922321ed9bc65d4ffdf439e472fd7ef871212350eb734f731e555ffd"
    sha256 cellar: :any_skip_relocation, monterey:       "aced30d5ace13627fdf0580f677cfc734e74c0c09aee0b10208a563f9088e0c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22329a61f007b99b51f17cad2b836a2c9694dba85564862ef79e080096182874"
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