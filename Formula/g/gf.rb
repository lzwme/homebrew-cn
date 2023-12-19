class Gf < Formula
  desc "App development framework of Golang"
  homepage "https:goframe.org"
  url "https:github.comgogfgfarchiverefstagsv2.6.0.tar.gz"
  sha256 "87c87856e41bb9543113cf56b0446e29c12ab73385c88581ddfbe0469099bcf6"
  license "MIT"
  head "https:github.comgogfgf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f191dc7b13732ef2d363c24449d88326d997c0547773f7ddfc91dbd29d2d387d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d86b74de9e45da4910f062ffd07a8b334787518955506843686c6fd09d27d38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e61b525ce129b28558dc6ad0c4baf9b9ff724e79053651911bca24670201bf43"
    sha256 cellar: :any_skip_relocation, sonoma:         "71163378686e994883605e71f7c4030c137dbda0753a7eefc4bfee98d7790dd1"
    sha256 cellar: :any_skip_relocation, ventura:        "3644932c4e88d9fc445a6f3c4209d8018c0cc62db2dc9878b2dcba8996e44311"
    sha256 cellar: :any_skip_relocation, monterey:       "3e55ec4dc1f61ef51db5c0f37a6b5e10af2e9630e3e5e6a85823c2b9bd9c53e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34a7b8c895b8cfc0d12292494595a599f34d7600c144457959ecca6be8fd35d6"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmdgf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}gf --version 2>&1")
    assert_match "v#{version}\nWelcome to GoFrame!", output
    assert_match "GF Version(go.mod): cannot find go.mod", output

    output = shell_output("#{bin}gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end