class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.15.4.tar.gz"
  sha256 "a197deedd0de7dfc958f1886316b881626030381350821ac39ee475e15be79e1"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe7218b82b6f0be9c91b1f9844986a336d416baa8afaff8613e859fe514c05c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04fe4bdad2860e69d76fad7a8c999e4dfeb2ef30eb684feae705ad838019d2af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "135b2fe8eb0a149f4c4f9971cbcd738a496cd815be271cd2c13187e07abc3ab7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba6e91db25c2ffd4e43d80e4ac700c5dc5f947fd276e62185334557d8589b20a"
    sha256 cellar: :any_skip_relocation, ventura:       "1038506938bad5363aa51ac583e24e937ea2c7fa56efb966ccb9cec3ca635983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9267a11e8dabf1c66621015dc1eb482e0e72d4a1c85965e300b1e78536462232"
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