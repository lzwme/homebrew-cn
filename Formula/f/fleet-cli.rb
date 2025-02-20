class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https:github.comrancherfleet"
  url "https:github.comrancherfleetarchiverefstagsv0.11.4.tar.gz"
  sha256 "81ef359b3c21b365045381d766843e9b95d0f3795985b22e20aa8cc040dc0f8a"
  license "Apache-2.0"
  head "https:github.comrancherfleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9779e374280180a40e4c70a24b392268895ed8f1bceb666041931b5796bd34e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a1b8a33868384e86fad257404bcbdfd939a11cf641f998e3a5e6713bedae3e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a8eed38a16e450cf47224d8ecf58406b747aeec88d92f1677c3430e33716b0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "11a9d728f608c820685f6d51213a5657b36f673bd9185857506513e8241534aa"
    sha256 cellar: :any_skip_relocation, ventura:       "f836cb413db43205edc7645e0004ea32fb6055f36af6c7ab8d8a85079077a662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b822b98d4d3c7071523678e7c56438c802e263eaa6f55d3156c21640199a535"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comrancherfleetpkgversion.Version=#{version}
      -X github.comrancherfleetpkgversion.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin"fleet", ldflags:), ".cmdfleetcli"

    generate_completions_from_executable(bin"fleet", "completion")
  end

  test do
    system "git", "clone", "https:github.comrancherfleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}fleet test fleet-examplessimple 2>&1")

    assert_match version.to_s, shell_output("#{bin}fleet --version")
  end
end