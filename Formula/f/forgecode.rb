class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.17.tar.gz"
  sha256 "0752345e46a5d7f3d07dee18cc63199133670d20a58aa272e3cf097bcd368eb1"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f76d5d6a8653c88a65c0282f6be7b35573d34e1e9ef4c10ac2483e68ee69995c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3af2aaff4922c476c80b94cea21eaebd69a8c05dbe9c772b19aa1486541632c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90573caab57238c93ac7d13a0d1127bde215b2e2cbf94e23dad0ae68171ab103"
    sha256 cellar: :any_skip_relocation, sonoma:        "72fa78e11287be625ce6196aaea9fcbbab36396ac565e2a287e5ce3dda78c856"
    sha256 cellar: :any,                 arm64_linux:   "62fe5b1e795da7a24111c410f4c6d5588df58263f7b93406193d693ea5f7d662"
    sha256 cellar: :any,                 x86_64_linux:  "47d62719145f2fa04424ba809f575b11ac83a992567a83c9e3a4b1b72743b91e"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end