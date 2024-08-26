class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https:stacked-git.github.io"
  url "https:github.comstacked-gitstgitreleasesdownloadv2.4.11stgit-2.4.11.tar.gz"
  sha256 "d13d876669df0e5066fcd9202f2e990f95e9c572073c9db4b2d3a2a212339b26"
  license "GPL-2.0-only"
  head "https:github.comstacked-gitstgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53a1c8ce2fc4ee91d505e73bb16c0f2597503f0a3ec186f69201db743b320bc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "428b2bee1aeb65476992ae935f36833085449aa210ec03876518562127ee97c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f0fecc59548667778763956930ebf62c488b02b71633a8bc7d17a20d9edebb1"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f99d7bb5c7c653473491220636929569bdb24c18a9cfc60d4a0460b82058006"
    sha256 cellar: :any_skip_relocation, ventura:        "9a69957686bda201fffca57305a6ee5bd75358f4d8172247d84fa3d7c83e1720"
    sha256 cellar: :any_skip_relocation, monterey:       "2167aad38463f07897bce9f5f21da1e78d7c19682dcbba9d071289190edfc435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d9f1d3b76e1fc1d560cee744a0f1be2f041a5ed1c53d8dca4a14d218973dcb6"
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
    system bin"stg", "--version"
    system bin"stg", "init"
    system bin"stg", "new", "-m", "patch0"
    (testpath"test").append_lines "a change"
    system bin"stg", "refresh"
    system bin"stg", "log"
    system "man", man"man1stg.1"
  end
end