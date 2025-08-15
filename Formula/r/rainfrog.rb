class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://ghfast.top/https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "2f4225f0233ea5aba223797d158f6978a33d2aa0f7d11146b009c77f4c4cc733"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ab8084cc3f1df6609a39acfa0abd638bd3e48bd9f8bb6c1671523684a5046ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b82d10e70eeeefd523f2e6c597a39d7db26ed0a6f6741486df224d3d02ef0f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9c57de3f7d8e4837f4b6349f089f7443479bef49facb104aab9c297c6b81a46"
    sha256 cellar: :any_skip_relocation, sonoma:        "75de5ff3c834598f742ef0daf2dd937516d1862c75835157653b0c8236fc0503"
    sha256 cellar: :any_skip_relocation, ventura:       "b14d27fb32409056d6fed0bdce82e6c02b0b478e80afec3797ab1f1084c31fa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56c9c1d5a7d477d7373f5c3f8fd2b464d028418fb9085e4785f27f93c98aa95d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba4d47ca8ee4d384af39adb9f8f89d6afb770cbcfe615de96db9218d836789a7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end