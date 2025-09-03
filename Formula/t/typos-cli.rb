class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "bd5080e4b418e07fc8a6c1d239fc412faf70d102b6585e4c76d15115d6c87c23"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab5f2031b8f116d72c90a688d90ad4d26ccecc13e031e1f23f8dff7b6d3bd5b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04425c4d889f462dc1807f9fc204357a6e8429c045b26479edc075e2851adda0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bb5f8cdf957897f55cb97bdaa78c196bc14cae2a14ff120a0a22d9ad1a95e81"
    sha256 cellar: :any_skip_relocation, sonoma:        "51c872a7623d66d06a5486d974e246150d3a94cc707fdc5bea323eb3077d03da"
    sha256 cellar: :any_skip_relocation, ventura:       "a8935aee8fe3539edb4eea9213ce233c482f4b78095ecc016f81dc085f766a7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e188d33e26ffa5e54d7db95a11193723b21475b450c0c120b676e1e567af045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72f7892e79bd867c4d234c347fa2a03882e26fe3c9864f64e7451c5095b1e4b9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end