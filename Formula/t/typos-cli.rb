class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.38.1.tar.gz"
  sha256 "f7e83dfecba57d778c916bd3d554129fd6d79e0fa781f605e83c7dd89e30711d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b3a5858988535bfd5e7eedb78a5d9bea8ae054e84111284b9d125c2b7d484ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "918fc0e0f6c603e80f7b8dabf7a909a45793aaf6a0811c2e2fc6e352b38d0021"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "293bafe20ea298750f5f0136926fa2b43f40533edf549e41f2de612fc7b3f5b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6479f5d72f6d57dd27b902ba34b5e8b8265ce9efb6a16f0ad397233ecab73aad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7420b5b597979b3e2da747bd9e7f8593e849aa6217cab1016bf8e9131276762e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e945c0f8dd12363a7add6c06633ceeefe8f13a2d8ba82890ded15035114274ed"
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