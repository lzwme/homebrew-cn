class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https:github.comrancherfleet"
  url "https:github.comrancherfleetarchiverefstagsv0.10.5.tar.gz"
  sha256 "4c0a91d691a4666d7cf8fe0f5466d094dfa4879772c084c90ffd33b10018de49"
  license "Apache-2.0"
  head "https:github.comrancherfleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b76f0f0466f5cc511bd645a8acfecb2c295d7601088c6b1005ef51ca6e2c3d59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4134b353fd4204521339275a02d2175f4dfca82cc5ec8bb4c46d8208f910b3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "718e5a2333465c15ab8575a9174120fd814eacb5ee80d9eac1d2cd3304c98fad"
    sha256 cellar: :any_skip_relocation, sonoma:        "99a0189652426112d73ffdeade0a802373a2fb48352c40fc89cb7c9be154f548"
    sha256 cellar: :any_skip_relocation, ventura:       "b58361fc27f7c6714b6b90097af9ae587028dc33527b8e61969dbafbf6f219b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cbfb2b90ff20e64e7ae2c23b42ac878127e98342caa7c59f53061ef79d8b846"
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