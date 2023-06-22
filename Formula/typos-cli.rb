class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "b821265824ede0ffd7b55ab70eb160fa9660245c602b875e2eb9dc6a3f6c849b"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b67d3966c13bf9142fc2b14baae050f9165879868596753a30aa9148e079d1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adde67c96dffafd4c8708420b42e206cb727b1eb93ac9afe0557c921fd8c29da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f828b8b65b67374c0a6ecad223815f447b662a9f376608f3f5579cb3a1b2a906"
    sha256 cellar: :any_skip_relocation, ventura:        "42413ce299231f5decc6ad6f5aef95bd59b25eee391e99c950d003f5aca593a3"
    sha256 cellar: :any_skip_relocation, monterey:       "594805f32b3eeefa8e2fc1a5064f2aeb5b82d53a522aaff0a09f1c6223c84d3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a91acefa38667cbfbdeb64de9fa89588732b54035dd4b78d7bd8e0d8251a7a1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55368a8a135d45124e4444c38e1f9484959c88bb0ad8b7cf3bde93e847700076"
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