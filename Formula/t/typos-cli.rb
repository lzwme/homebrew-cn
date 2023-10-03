class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.16.tar.gz"
  sha256 "ded365931cc9d6e0c54d814f0d9bf7bd34188ec4906f712fc99df6e9d9dbc410"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffb3fb7aa3ca95610e824cf0876a1e55ed75d0355ed7f5ec2cbd74358d9af7a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2aabd259988b76adf3472291bca8393b244572b8455b3e76d3fea21b777bd265"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a72138d21b01163ce1b3d398e7ae1d0296888ad1ba67c964ed6da739b3c6b8e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "2800e39711d41fbee20caa132341f6b8446fffe21661216bd7af52c3b47a701a"
    sha256 cellar: :any_skip_relocation, ventura:        "3bda619448fe0ce4e871e998c0be09c42deb7de79f9ce107a3bfebc609a4c326"
    sha256 cellar: :any_skip_relocation, monterey:       "5eb3dc931724993e73cfe5312529c5f1f3f390691d2e97ef016902fc3273d8cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a04ab99aa58609bde6db8a45c633cbb9597ebe1eda31012f081f6033269032ea"
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