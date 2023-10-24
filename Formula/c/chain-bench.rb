class ChainBench < Formula
  desc "Software supply chain auditing tool based on CIS benchmark"
  homepage "https://github.com/aquasecurity/chain-bench"
  url "https://ghproxy.com/https://github.com/aquasecurity/chain-bench/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "e1080490aa70620de9545ab361e0516fe69e61d8bab47a016d0dfac4123a353c"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/chain-bench.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7050abfe7d09c162a6a2b53325cffdfcb1345b8a9f1f63f4475a59a43ea885a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d31556ec7fd0332b2e585c7c8d2228727aeaf937853aedbc1f41a1b494fdcd07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "893fbb9ee133f6e9d84f7de36e45ba887128ee4192f06b28e3944f90ed19d691"
    sha256 cellar: :any_skip_relocation, sonoma:         "904a256edda978524279d1b5bc32ea74a7303983c374252c07b76b19e85b612f"
    sha256 cellar: :any_skip_relocation, ventura:        "a231cde832b749d27980418bffb8398e0ccb7099f1ceb9cdb657fcec24951c10"
    sha256 cellar: :any_skip_relocation, monterey:       "d94601127ee6516a0004c388e5779848136c84b20e485f46267b7270b32afce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06ac6ccaf7d6204e3f6b2e22f46dea5f5bdbe500937c25e33857d5f68c6e7603"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/chain-bench"

    generate_completions_from_executable(bin/"chain-bench", "completion")
  end

  test do
    repo_url = "https://github.com/Homebrew/homebrew-core"
    assert_match "Fetch Starting", shell_output("#{bin}/chain-bench scan --repository-url #{repo_url}")

    assert_match version.to_s, shell_output("#{bin}/chain-bench --version")
  end
end