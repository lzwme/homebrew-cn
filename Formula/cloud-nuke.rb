class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/cloud-nuke/archive/v0.29.3.tar.gz"
  sha256 "6a32a5342ca0c0df89b1b30c056ca470dbba4cbebfae66c778a2c3c1e9efd8ae"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10ae4c977d5f868a1e729254f22e26820cfb834852b0ca709d7a2b6eb107220f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e491508ba602cab3b04b7614ca3710cb8af1fd3acad0e7599ec274044eb090b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c45ce0b06e53b52b9ee9e0f08ccaf5eab47cdbc6e591a604f12699fca7da420"
    sha256 cellar: :any_skip_relocation, ventura:        "dedb2f080c23fd5ba0fab70f751f2cecf20bbe8e5759d60a45809d1f9d7824e1"
    sha256 cellar: :any_skip_relocation, monterey:       "83631595c8c1dba27adf8658023159a6ab616dc9bb2402549a525a99279639f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b561d5726088b3dc5971e28e75e3c35aba901f8df55c8c40f5daada0b2972db6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f7b72c68a5405346290b1ebbed01cb229a36a56c1d404108fc159e71067085a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end