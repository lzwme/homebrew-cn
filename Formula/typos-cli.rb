class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.14.12.tar.gz"
  sha256 "ee2c5febca11c0964ebf8689cdcafad4725ca461cb3780791715ea14124f3278"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b7d5bcd2d738361a7a407293695815ca0620fffcc32f42d0b76f3c48072940b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9b88e1df2dff715df6a4a3d0de9ee65b08cb8bd4ea4b2cdef44abb6741e8221"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ae29581f53f9729f18402250890532feaf3961c869d593d825f11dbf9c2b5d3"
    sha256 cellar: :any_skip_relocation, ventura:        "4ff21ecbab8d5e7332c399b2822036715830ace436d7886535d6c0ae4407771a"
    sha256 cellar: :any_skip_relocation, monterey:       "70337342fbb0c37c632ad84292a4c3a8f38f7a59ff42b1bdc99874c8887618d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf3e37dba7f73e72fe5f1c2f22ccde5dd12f88c2da50a1bd5b4a1dd9cce7b3c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1dd33e4986ef7c78ab1fb4c98c6c61ed5130d8d9baf1229b785bff0c18792bc"
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