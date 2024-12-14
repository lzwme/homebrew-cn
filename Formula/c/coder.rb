class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.17.3.tar.gz"
  sha256 "b920a63d618934f9987125cf1731e2462a7e31e1a685f9644e9e294c4574af79"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f6f42f51350eabf78d73b7ea47bd2ce2c5ce8bb0866458be63775d0be8d42d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa81e30ca0a492e957b194c0c9873bd0a04ca5b79b220562ebdec3e2e3e00b89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f570567ce151e508cf288ea32ccbf465edf00ddedf452d6a230a84241d2dd0c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5db74b4a0f821ead9322ce18caceebfcd6f1037dcfcaca4b9e1f5001f4dcc1eb"
    sha256 cellar: :any_skip_relocation, ventura:       "1ed99192b019e421a81bbcab943f4471357092b1fc91b46886ac044c1b261c9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d53ebacdd6fb3cd7efef6d6afa60f072390f4fbb3a85c7232ead9ce316ff020c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comcodercoderv2buildinfo.tag=#{version}
      -X github.comcodercoderv2buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", ".cmdcoder"
  end

  test do
    version_output = shell_output("#{bin}coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}coder netcheck 2>&1", 1)
  end
end