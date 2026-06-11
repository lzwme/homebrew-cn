class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "5626bc0f319b9c9d621cf5060d6c53edf719f5b997b69f35a39777301e2a90b4"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4330d065d065a1c6568ac44d1d8ddb401fad328cdca7a5632315522facd9565"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4330d065d065a1c6568ac44d1d8ddb401fad328cdca7a5632315522facd9565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4330d065d065a1c6568ac44d1d8ddb401fad328cdca7a5632315522facd9565"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ecf6b986b6007d99c9dba4d7dee314700ed820bcc74450722cd22f69d728334"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58e698172bd618fa3e99693f5e8b121ed478536fb69782a170d20ad3e2209dd1"
    sha256 cellar: :any,                 x86_64_linux:  "78401dca02a0b87ae0bd659d8d9ca22e517189210a180f27ba85a6c11a4436c1"
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