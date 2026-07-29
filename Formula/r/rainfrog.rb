class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://ghfast.top/https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "843bc989714f6bb71c439faf54079d520fcb5eaab8dd80eb7d3e54da094823cd"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6f9d26aa6c1d085491343bda3501a959bc517eb59975cdb4858487217c6ee4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef41a4b013e71c1330168f1976e99c328990ee00580887bfce1b62974a024d72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eacc0fde9bae1596b31b3bfd3948515d6dc8cd6291190aecc569187aa90f019"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecd00b230868a9b71e4ccec18cbece24ba7969beeafe41fa615c3ff94bf21dd5"
    sha256 cellar: :any,                 arm64_linux:   "5879679f8e08bb502b9ae8c17867ce8df464b512eed38f8a7567decea1e4627a"
    sha256 cellar: :any,                 x86_64_linux:  "0ffce2a4e3e56355317c7536dbb67a0f1f49a9bf65807672c63388d546dd84f9"
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