class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "54a57fb6ffd29f4538afb5ce78384ce017672d14207168d0afb115171a355d38"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65aea4db5ae7dbe0081e47e47593dbbeb17a3a580f29473398cf3ee3d2484f54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40b9ea0a9f270093da9295120898c181f1f259ec9142a06524eb072b4db6f70a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a8a20596db13b072375f97beaa4604c79cdb304cf7f728669c5b401c83f7c61"
    sha256 cellar: :any_skip_relocation, ventura:        "ccd462e857d2d50d3daefa017f975bbad7546a29c78e0e04cd9572dddd3cb1c8"
    sha256 cellar: :any_skip_relocation, monterey:       "0a9051f513c360e299887cf6d185c1d6d04be34e72772569344617cf5492c257"
    sha256 cellar: :any_skip_relocation, big_sur:        "991c15ce783978765e9943a05d33a31c45e713381119631ae4e4515846e4fc2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf20dd95b700b0f29ef7cc48eb627fde0e226cd301eaabc2276eb4a0bda1798d"
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