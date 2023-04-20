class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/cloud-nuke/archive/v0.29.5.tar.gz"
  sha256 "0220845165fe5968e1c6d54f75f0a4c986e8912f081f98bc5e5f6d6610725ceb"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7f8e0ad823ed6d2e0b1cc371771c99bfa96ead26a0b6ba7b1e8de8e87321403"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba7bfa0ec119ffe39a6897768e5d64390ee66ff20d03ee277d2b3bde94150f5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5588e5ea2916955117550026d8d898f21d9e889a748741b1055bd5583f68d6b1"
    sha256 cellar: :any_skip_relocation, ventura:        "99e6f6e6f03c12fc25212e59e4c66d33d7da3d54809fa22bd53271b33e4c0fae"
    sha256 cellar: :any_skip_relocation, monterey:       "f95d9d9630ec02a44984902dc27c24fbb2973953d88e35798a095bc34556bf0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea69297de1e97e6cc82874f5c09075f43588a464cfd7428cb2d15b2a77e9cd4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffded7146f0c43d5724aad01c48868da3ed4435f4bb458ed707e452fdfc54765"
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