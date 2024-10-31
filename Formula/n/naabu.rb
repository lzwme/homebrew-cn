class Naabu < Formula
  desc "Fast port scanner"
  homepage "https:github.comprojectdiscoverynaabu"
  url "https:github.comprojectdiscoverynaabuarchiverefstagsv2.3.2.tar.gz"
  sha256 "bfe1e5752902d28cf8ff4f3194e1bab97e457813c202d98b0c54ad10bd9b52f3"
  license "MIT"
  head "https:github.comprojectdiscoverynaabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a824daef7ad067a9cab585eb9bcf5a4053493c89e80b142f4199a2bb4f99592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d1819b138a60629f17be3215ac2d458846775118facb0cc8e723e74e856443d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c626d427e77628a2eb75a690fda8285b8b4f131e227795391426e6957a89c75"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a396034b7c31ed86158d6c10104cddac1288eced847de8a1709dda91f8ce0e8"
    sha256 cellar: :any_skip_relocation, ventura:       "8938367a3c27711389826e9576e89e6068ee837c0ba15f2cd0c2c0495ef3693e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e13d192fc067df0882cbd88fb60178cadd5e3369c406d05c915ed7153599fc10"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdnaabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}naabu -host brew.sh -p 443")
  end
end