class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https:github.comrancherfleet"
  url "https:github.comrancherfleetarchiverefstagsv0.10.2.tar.gz"
  sha256 "032a1ed89ed79ba0311d973926f0a9ba8bc01cfc8e76e8bf9f9293c549c9f806"
  license "Apache-2.0"
  head "https:github.comrancherfleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ad6aa75810f3b2a239bcf9691bac31376327b14e9c1d78edcbc37d7e3aa088a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a8ff37bfe19bbee3863750ec5aaf4ac1d3e01c4be8707b7c640fa2ed857bb71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b97c93898f04803c84e5ccd3f2abda17f65bb0458928eaf53df2b39bc6cb042"
    sha256 cellar: :any_skip_relocation, sonoma:        "a97326db62c6fa97f5590e7d77dc536a28362293bee937d68a111bea3401ecc1"
    sha256 cellar: :any_skip_relocation, ventura:       "70a2151a19b51a64a9054dafe2ac7c2da5ca64d07e8c4242be1f743108f7f343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d838854231115c6e464216d5409c938dc1e1a41009acb546798d77d7522bb691"
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