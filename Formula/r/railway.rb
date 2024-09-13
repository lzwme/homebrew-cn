class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.14.0.tar.gz"
  sha256 "759c7128d8abb8f56fd0ab231cba4e686a4238d43b319c8dbfed38882606f100"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5bea054ee656e29fdd9769ce3c6d0bb143c8a7da5294e5dd99fafc16d5dc37a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcdb2c5f381cbd9f821d0af0ef5c34ad2e4eb065080f13fabf8b887414cc583b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f46e7949a0043bf11bcd7bf093aa9efdaf0eb66394575e49d1b8512af0e4f252"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8e2cdc9263f9832ccf3deac37f9790c569d723b852abcd7ba3f73fac92ca53b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d173a3faeae9fc05e2d806bdcae8b72c351235e83d505eac0ecd54209900ff3e"
    sha256 cellar: :any_skip_relocation, ventura:        "f4550ab0fdc33789ec1abf780bda4c8dd001b5c1096bf72a4edde7ee2c5bb0e9"
    sha256 cellar: :any_skip_relocation, monterey:       "95caa5564e2875c732d8c5fed851f5684b5111ae942ca417e17246ed982bf8ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4cc5a138b7f108c86745e658d84badc955cd3c0253c5d3ed21e4598d6c4f3e6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").chomp
  end
end