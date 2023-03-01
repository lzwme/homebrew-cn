class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.13.14.tar.gz"
  sha256 "5c16767a96d21d83aba59cf0d065765bbe7dc435ec39219264ad24447a786062"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab65fcd9498ae9725ca7177eeac94510bf3280c81967903ea639ee2114c317ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1128bf72840f6868de550c09f79e9d79375f7fe355e83a1c45e4816506b37d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba76e458d302debb6c04413543291a8db34df66a6d9d20338b08c0ee4d6bb3f1"
    sha256 cellar: :any_skip_relocation, ventura:        "879b6791ac8ea6cc065c7e98b1483587797b259201b9d50161d0cc39a853a3f7"
    sha256 cellar: :any_skip_relocation, monterey:       "3e702c20ac4a857131a75f27be649e6bdd0ce9b49b1c87c0d81dcd9d46facd44"
    sha256 cellar: :any_skip_relocation, big_sur:        "e76b6a944479f3b82b00e1c27444be962424debbe86de4b3bd143c68cd246146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5beb223bf97cee0660213598c466e8a9aece08357579652761e9fbd658946c2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end