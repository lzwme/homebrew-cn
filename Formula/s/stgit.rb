class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https:stacked-git.github.io"
  url "https:github.comstacked-gitstgitreleasesdownloadv2.4.13stgit-2.4.13.tar.gz"
  sha256 "ca049cd212f406d8ee8f7eeb5f454e800ea064b8637ff9af9c909157329a4d44"
  license "GPL-2.0-only"
  head "https:github.comstacked-gitstgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f55e1c5d66db6308b11261ab5e0dae5a0c0cec3ef88398c597e3201ff780d0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83f84a83d10a15cb31c7fdf879dd23c519e362e9d605a3859a11f211505536a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "817aea397b5b9c46251208d0eff1eae825b85c3731de8bee946d6ef0e5a4bac0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4f2edc697ec8571bbb9bd4ee2686b9d22b2eb161b1f18ff509b51185941ab83"
    sha256 cellar: :any_skip_relocation, ventura:       "f276f0fef9704acb39b8062181bbe9f1bba31a1e446420354b78f80f23a2c3c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c660a3686d1227e1ba36e2f1b7bceb7554bb4e9ef6e38922653c0b62ada51df1"
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