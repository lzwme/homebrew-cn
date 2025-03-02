class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.30.0.tar.gz"
  sha256 "463142f3e7f3288040668203dd1aace336d9dfc2ab9834340845490021de2534"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dceceb5b75f45ba81535c3276af26f434c77135e34c514832c931ba28e01abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82384725012a36f97cfa3056a8d123a56738b3a028a55af632792c02b705d2f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f985551d8e92eb1e258004426c3f9cb6bb46ca43f281d4c26b7a114b81d15de"
    sha256 cellar: :any_skip_relocation, sonoma:        "e867e02d4506e7068a7d35c8a0ccc89563798ce261b00edead6e166653a66b40"
    sha256 cellar: :any_skip_relocation, ventura:       "b80be638f043e3276bbcd20faee7f45e7647aafc40180c71fb2254bdecc071d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7b39260f5695990d5d88f0b9e323ea3c7bd4fa02796d7714417fc51d3b74dec"
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