class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://ghfast.top/https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.15.tar.gz"
  sha256 "685b5dc0072b132cad0871fd1d42955c6db3149bd0f7181d2c063850a7d2b645"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e24097b47412286aed62c0d07bfa692e46c0eccc0f00df4719867474794705d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "244fca5b7f45d3646dfb82078be7f6a69ff3bb288d67b52e5ad0d8d04531965c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f60d9c0e7e334d9f296ee1f39ac3ffbf9304597bf023dc35296f881abc36366a"
    sha256 cellar: :any_skip_relocation, sonoma:        "757283efbc32769aad5f10119641a94ddd67d6787914ecf85e4d5ffbd682d4b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b46619045607b61e8523a21aa0ac1adef9923252f1066bdb31851b51314c8fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5cdd7b9cc2d39626de8ce93a60292350cf27df3eaa6069696c9edde2806af2d"
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