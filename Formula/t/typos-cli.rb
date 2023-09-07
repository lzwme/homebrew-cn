class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.11.tar.gz"
  sha256 "4a81f6f0af1601465877f685cf3a5a50018cf39b79e4f09092e8bc797a10075b"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7bdd844d0dbfff63d05383403bef94b9a2156c067c807eaab484dd5c613c04f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e992f88dd4c1fd39b47556043524cd4ead8b18106156d4b7b91a01d460e0add"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71870e40ed61adf4c9ac3d21c8e3760af6a9552786b4edc8de673eb3b2759a66"
    sha256 cellar: :any_skip_relocation, ventura:        "b901829fc48bd363ab5c3361782fdc8236e93c0d87b171bc6c093adabeee8bbc"
    sha256 cellar: :any_skip_relocation, monterey:       "627e0e0066137ee8d82ad285d6bf20197e3942f1a171c3e77cd2587106a78462"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c66448c5d5342c400812f46aead70bb23892feb34345293b9336f5e20c5746e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4c9a58cf1d1e08c0c826ea1b366cd62b1ee95544d22a6dac5e3d700ae4840f0"
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