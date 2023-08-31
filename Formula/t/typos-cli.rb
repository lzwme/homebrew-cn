class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.9.tar.gz"
  sha256 "3daa6692902c0cd78f0e5330a294bfdc1b7656c8276b2353b41b159a59874949"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "892163a1bf5b7afc70185a0e147f042b7a61eeff42e618faacae74fc2481337e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78f38fc05e3931a08c9464316024d30a67dc1b1f5cb6acdb4ab129e5daef876a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f38f147bed3bf5a01dac0d0b66dafb1e762681b30d6bd1d6899462a419ead0a"
    sha256 cellar: :any_skip_relocation, ventura:        "e0709c0f6946f167967a9f07e540bac14669816dc8661b90eb9b9ed4225e494f"
    sha256 cellar: :any_skip_relocation, monterey:       "d88648dd721937ea74e9a94006e1d37233b70b021b2f449975624ae9e8d01e07"
    sha256 cellar: :any_skip_relocation, big_sur:        "a84094946fc4cc480dafc8f012c19cae89134686e2680509711a240c48144d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfc46c307546835fa4cb225b76156f787e60b9fd9b0340b01eb3f6ce27f95a7c"
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