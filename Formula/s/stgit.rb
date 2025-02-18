class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https:stacked-git.github.io"
  url "https:github.comstacked-gitstgitreleasesdownloadv2.5.2stgit-2.5.2.tar.gz"
  sha256 "3938154a9c3a7be958e2d747bc6a232029156d051b72aaa3f02a86fe6349db35"
  license "GPL-2.0-only"
  head "https:github.comstacked-gitstgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d348a4dbc0124bcf66a6446da477e5c81532b9a1cc90db647084f19cb4689a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05fc5caa533922709b44a460a7fc9a036e488ff6e8532eb90349493843f8564b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93792cc59797ce9ac4d7300c90de0eb3aae9f6ebb028bc10566fcdb51ad6795e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd23c619fc7593a7eb3e7c881f4b241277b79c965de2a6db7d4bee77215cd683"
    sha256 cellar: :any_skip_relocation, ventura:       "4dfd6a143eeb5a749fa31dab4d1cc264609b003ff2722826c0bc6fa7a01c3449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d5fc1698a8a666c48688099a109df8b189a899862cfc1194328bd8a949274c6"
  end

  depends_on "asciidoc" => :build
  depends_on "pkgconf" => :build
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
    system bin"stg", "--version"
    system bin"stg", "init"
    system bin"stg", "new", "-m", "patch0"
    (testpath"test").append_lines "a change"
    system bin"stg", "refresh"
    system bin"stg", "log"
    system "man", man"man1stg.1"
  end
end