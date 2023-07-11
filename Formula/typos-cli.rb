class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "0e1e5c5c13bd4cfd3afd528fbdb3f65d978068441ebe5243b47c47bc963377a6"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57073e0ebb6de8484c9d07209e0958e465a6fa99fd33e1df07e526c8267f82d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "564dc244cda9cb94ad7ad1f70880f81745d8c3885eb97c0d93fc196953271f37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91796025aa8b082c150cb49448131298aed74520d8bf1bcf7b04f1c6e9af9711"
    sha256 cellar: :any_skip_relocation, ventura:        "7ba9aa8b93f28b677746a8be4bbd8bb210e18f13b19e612ec020b40cf53c0835"
    sha256 cellar: :any_skip_relocation, monterey:       "690c76abebd027a00eda7f908281cbf7f1f4f20d1823ec16da858afc6014db74"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f0e5e38dadb92e926eee1404e435ec06754fd57864736bc2d012fc21fe9bf06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a65375d87e72296f37c92bf84bfcee9738ec451d65a9e83e5bad0e5aa276b1a"
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