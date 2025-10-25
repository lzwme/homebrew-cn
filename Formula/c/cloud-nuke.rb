class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "ef2f830ea4d289c4f3424decaede2b2cebe6ed9de268985b45b56cef40c6b20c"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "216bc392316cde622c2ac673c9ba913d013b2d0efff1de800b7cd6cc7c965508"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "216bc392316cde622c2ac673c9ba913d013b2d0efff1de800b7cd6cc7c965508"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "216bc392316cde622c2ac673c9ba913d013b2d0efff1de800b7cd6cc7c965508"
    sha256 cellar: :any_skip_relocation, sonoma:        "808bf484a27f22026b48b4caaa6d3afc9b4d404d7ca1690b9b85154a26fb1b93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d964ff5ba454fcc68a2664234b41dd282c96958092a977c7f7088a01a3320e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c50e39752880c6f8463a23863c2b40f968dce4900dee9cf07e848131718410b"
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