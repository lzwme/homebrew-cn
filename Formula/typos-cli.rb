class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.3.tar.gz"
  sha256 "73c0d8c4f617a58e3e7f250fd7210f00eb1dea2e4476309329b620eda38a4220"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1b2f7d81f0aaa1f204e0df8d3e39f98c4c9f5540e55548a651f77048ddb7c2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c92ba0f5fb3569bb432e6ef977b314fb42bea44a595905d378b80857d194ccbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00408355c11f54ee9c7aeec708c544d5e9fdac34168ed8c9ea8690a7e881831c"
    sha256 cellar: :any_skip_relocation, ventura:        "68b9f7fa163ad538a8841778a429e36c79c974bdcd5ac4d842a10e375d7aba8e"
    sha256 cellar: :any_skip_relocation, monterey:       "cca9756f94770a418bcc1befb3712110d665c9eeb4889461e84d3780cd0981ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dca09bbc2b2d9400328424a8c7ad8e551b0baa0476af665d7840d007c0ccf81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca65ce9a511dc71b97517e87b661af656a043979fd1f9aa0710b68724f01e829"
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