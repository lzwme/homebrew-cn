class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.28.4.tar.gz"
  sha256 "acfbaf16d61fb35532ddb91a32e720181450487f60fe60757f72c3879496955d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6a64c66d8561e7e3fd54b828b27145c206e9dc7fb118198e56bb25362f2939a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0e28d2e5d54d389e44848a067e45acd8f6386b1744059fd36ab623943248c58"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d5088f4ea34fb9781b1bea0d22909f2cb3d64a37c867f98b0afd39f70f5393a"
    sha256 cellar: :any_skip_relocation, sonoma:        "352d57a858e13b32f2ed4ac8a068bd293d4c156fea22ce5bf7d02a2b1f6c9a56"
    sha256 cellar: :any_skip_relocation, ventura:       "36ecaebe46ae4066a75bcd8c28d5db2a5e12bac0b755ff5066b706a8069e3105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eff2ff2455e29b06decdf4abfe51ff3d02f9520e58f0ea116e0b8f916ade82e5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}typos -", "teh", 2)
    assert_empty pipe_output("#{bin}typos -", "the")
  end
end