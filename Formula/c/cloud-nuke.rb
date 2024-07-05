class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https:gruntwork.io"
  url "https:github.comgruntwork-iocloud-nukearchiverefstagsv0.37.0.tar.gz"
  sha256 "97bde5669557c634cb900f6dfab7c5b2e6187ddd51c9a72bf01e13852833a7c0"
  license "MIT"
  head "https:github.comgruntwork-iocloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fcb4cabea22e924eb0b9e8554c6fd0ca80e541a146ed167be92efebdb492d59e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc3af042a879b6ae9db7d7f2f35805e0eaf7a072f7924ab6cf48cdfc492f7795"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "678133a2b0277c0b1289c26f053322d87a18f5f69757f94fff4225481c410e5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "201c235b250b1e3a920e150834522e99c0b614c39fabaa6fb76d818a812b58f3"
    sha256 cellar: :any_skip_relocation, ventura:        "ed02602363e932e4531b85d7f1da3d8b7ee9c3cb48fc02b03fc067707f700817"
    sha256 cellar: :any_skip_relocation, monterey:       "1e6fff7f02d35a115c6283c6742b092250ba07648528df972e9ac48e1ffc99b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e7f6cc6c5052966f4d77f6f1b8c5a87013bfb6bb38fed69cec7ffd9fd901c4e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}cloud-nuke aws --list-resource-types")
  end
end