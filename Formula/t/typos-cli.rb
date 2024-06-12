class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.22.4.tar.gz"
  sha256 "47b64804b33e22a73dac35968c19e3bfeede419957291f7746a75e2dd2fe1172"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b64ddf78480f7e08b2871f977435905df30e42c15ca3bc3630e00c818b45772"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0933343f64171156f86ebbe4ea4e3b8ada67b5fd649e776888bf340fe5b8345e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ba298bef1887af1614612e0a20a6fd3fb7751399470c30ff5009c1de6a26705"
    sha256 cellar: :any_skip_relocation, sonoma:         "9576e46af4a9ee9400b3d6209503181018e0e0f74eaf7b7d28cd011a1e1a731b"
    sha256 cellar: :any_skip_relocation, ventura:        "cf737ad33f04158e75621387abe88cd662e5377b68815669b0fde33fce7558e9"
    sha256 cellar: :any_skip_relocation, monterey:       "3fa850df7d0f36e5d88cda6f192e12b2c1bb9f7517916480ba0f969fa5054910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9ecd4b655b4fb5656e1d71ed634c55639e9c73e6e80000299ec70a33103bcaf"
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