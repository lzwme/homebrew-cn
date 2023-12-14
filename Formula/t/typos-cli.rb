class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.25.tar.gz"
  sha256 "e5541cef7727163c332e4aede94bc6d99802c472bcbcc0fc69502601fac9659e"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9de4fdffec0ebe25a69603446612a4e712cdb1680cabb8ca42fe5d34ed3eb37f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eeb1402097d2b6b7db00f6ecb3aec6267dd24d169058e3f3d47873b4f3b78ee0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "904413d15b568e6babc74e9992196ce1da52e06d7ea90dd021ce71ae4ebdfb40"
    sha256 cellar: :any_skip_relocation, sonoma:         "850654329733e1bc52b64dbc3b5af39e768e28ee5c11c84623f9879f47f73254"
    sha256 cellar: :any_skip_relocation, ventura:        "3ce92fc7e3285d5d12da71e4837f56fd34aba2c85371309dac508e760568f307"
    sha256 cellar: :any_skip_relocation, monterey:       "acfe59d7dee25b99cf29928b041ee3a15879b2b9cb03c7a2a9f85a702ef78c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7ce2ffae364caa9bfd2d00b431ee1473ced2525e943160b5d99364fc475f6fd"
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