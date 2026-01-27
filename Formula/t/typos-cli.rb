class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.42.2.tar.gz"
  sha256 "615f2c3433ed6f89ec7dac44d30f384182ff24b675dc21ce14c1c20a107066e7"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da6d1d681c6c06d3945ff333e6070d8ef32d8d872d45ccca7c4efd2941843bbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc2d2bca12ea3e42b9ded385ec8e320e42f00d831d13ec81b1e665fc471f3c4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35c9f151695a1d71e89c95116c700a249972096ecb8c52147b755d339ec5cf59"
    sha256 cellar: :any_skip_relocation, sonoma:        "781a72fd68a5a4e1d628051d9f2d8c576579abaee40742f9cb2b55ec1fa874f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9210c0d5025d382171e1db4fe2dcbbf95e09f33da0f980ddbc4d2dd9b0eb57f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51bc1d27112c6a21d99e44d4a06838f75a1907a67aef7ae2568516af738969ef"
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