class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https:github.comrancherfleet"
  url "https:github.comrancherfleetarchiverefstagsv0.11.1.tar.gz"
  sha256 "4a48f0767154ad27c24baf6deb61152ba84abcf907bc0f371529eaa21fa9d26a"
  license "Apache-2.0"
  head "https:github.comrancherfleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92531f28506a1d98b616a34363bd18216ae7772c534f0b402c2bc903ac745186"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42a6de17f6bbabbc21feaa442b40927df3c444268fd07d830925de85a21f5e9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d34370345b3eabdce73d22ddb235521e7b004f1905aa40315b3abcac67c6f5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c826ddb0d103e608607ee46719152ec402200b35ce004bf5dc674a34083c844d"
    sha256 cellar: :any_skip_relocation, ventura:       "532912e27ce8a6c2763af6f165b51f682a090d5ef7c57618b15260b3222a1e74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c637835d5986a38632c14322b31881ffc7340790cc67ec811ad5a091565f010"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comrancherfleetpkgversion.Version=#{version}
      -X github.comrancherfleetpkgversion.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin"fleet", ldflags:), ".cmdfleetcli"

    generate_completions_from_executable(bin"fleet", "completion", base_name: "fleet")
  end

  test do
    system "git", "clone", "https:github.comrancherfleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}fleet test fleet-examplessimple 2>&1")

    assert_match version.to_s, shell_output("#{bin}fleet --version")
  end
end