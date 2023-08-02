class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "1f1d3b78d453b82c257697fcc719606e5e80c707350844ffe0f4b00b76a324c5"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fef0114a6817d2302666fbff523a1fa26ff21ab8783d454441a4aeb888ea0f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1dd197200f1c17d1eebcc4ac42b295d42ec59259ea03034a72211a5dd3ea978"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f8e694b1732aadc0af8ca309fb7bb8a478ac6007c664dab8b59643eeb18506e"
    sha256 cellar: :any_skip_relocation, ventura:        "4fcf16994b6c5cc331fc651519c637fbc7f42a184abe1a4d6b294fc6be5fcbb1"
    sha256 cellar: :any_skip_relocation, monterey:       "8e76079e9b68f8114c8ddd8cc270cae9b846ed4382fb55688b10f6aea5c4cabe"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1b4a5d66d954711810feb8dce7afb68cb832345efe07b32d1144f3f208f336c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "298178f95645b1411717d5c392df360f4578e345ac06e4d6605787be9ad3dfc7"
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