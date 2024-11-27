class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https:github.comtilt-devctlptl"
  url "https:github.comtilt-devctlptlarchiverefstagsv0.8.36.tar.gz"
  sha256 "fd0a4bcee6b528ed6f3dc8d66018c54882ebc6a326c759f99d48cf90b818e570"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d70d92bb0b62a7307346826bb5d7e939b07c13ed0c5b401774f76fb66c0c38c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1fdbe08009b9bc48865bfade4148d384629764caf4585478072f93d8a506c42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35802eff36bf61758349dbd5a38be3547d8aa57a690e2c9de0db8ec0b2e3542f"
    sha256 cellar: :any_skip_relocation, sonoma:        "578e03987d6895a408d990c1867030a4b82e8d0b4bd41f730cc0bedb368db22f"
    sha256 cellar: :any_skip_relocation, ventura:       "4b79aa8e9acc523d1d6dd7f88df357a8a87dcc627682fbca13787519c3716e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86fa05b3db3d6423a8809322180aec82f6f2b6fb801bb5f91e4307e44a45687f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdctlptl"

    generate_completions_from_executable(bin"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}ctlptl version")
    assert_empty shell_output("#{bin}ctlptl get")
    assert_match "not found", shell_output("#{bin}ctlptl delete cluster nonexistent 2>&1", 1)
  end
end