class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.18.2.tar.gz"
  sha256 "cd49df69f061a0799f202dfbd293e62bf6492aca4e528a83f346d803402b85f8"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b21231d7fc2bfa225d65ffe03564974770fdd54a5cedd5e188da410bb86f2ff5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2cd59c4e9f083a76a58259bf2d5eb98ed54107924d5429eed15572fb2989f5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7328f7a18caca9369e8235f3f535d50a50ced62584aa8199fd974143cabf892"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f11fbfefcb500a3643c9e05f69a2bfbc81430f94a5ca77c2d4a6ba26acf055b"
    sha256 cellar: :any_skip_relocation, ventura:       "1b391288e035b5a886d732c93e4d1e01d5711fc57791887e9e6dbee3d8278d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24f7ceb40cb87868f0ed758cfea8eac9c29b67c5593329a341d65f579f4997ac"
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