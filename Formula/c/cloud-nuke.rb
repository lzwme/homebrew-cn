class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https:gruntwork.io"
  url "https:github.comgruntwork-iocloud-nukearchiverefstagsv0.39.0.tar.gz"
  sha256 "eb085ab3f30050c2eeee724696b81d075f8300f2ce3dd7f10f658d811ac3a6c0"
  license "MIT"
  head "https:github.comgruntwork-iocloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a1a154621c3e2309233516ca923b3731b9bee9b84fe4f034fa56d7eb293f954"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a1a154621c3e2309233516ca923b3731b9bee9b84fe4f034fa56d7eb293f954"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a1a154621c3e2309233516ca923b3731b9bee9b84fe4f034fa56d7eb293f954"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1003bd78a32461e6154796cf0f506c4c9f7075935a26787735e3e470b81d808"
    sha256 cellar: :any_skip_relocation, ventura:       "e1003bd78a32461e6154796cf0f506c4c9f7075935a26787735e3e470b81d808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d5325d05479fcaf45a8064bafd14a7fec6b33553e834cc7e8b6e2602ec134a6"
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