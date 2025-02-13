class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https:github.comaquasecuritykube-bench"
  url "https:github.comaquasecuritykube-bencharchiverefstagsv0.10.2.tar.gz"
  sha256 "39d119e59eceb84dd78ff2afe013703fdb90edc9426beb9b9aa3b4b13377f46e"
  license "Apache-2.0"
  head "https:github.comaquasecuritykube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "445d09b802c78126c865f4e1562ccfad8e1ebdaa39f79d299d13dcecdc6a5a45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "445d09b802c78126c865f4e1562ccfad8e1ebdaa39f79d299d13dcecdc6a5a45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "445d09b802c78126c865f4e1562ccfad8e1ebdaa39f79d299d13dcecdc6a5a45"
    sha256 cellar: :any_skip_relocation, sonoma:        "8994977154d5dfc0fe97194d3c8167b833459f4965e521d1678cbb9a90e732db"
    sha256 cellar: :any_skip_relocation, ventura:       "8994977154d5dfc0fe97194d3c8167b833459f4965e521d1678cbb9a90e732db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95b45680f4f3be2d05b304e09075c5aaafd302c8a89e9cbf74a24c67cdf6e33c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comaquasecuritykube-benchcmd.KubeBenchVersion=#{version}")

    generate_completions_from_executable(bin"kube-bench", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kube-bench version")

    output = shell_output("#{bin}kube-bench run 2>&1", 1)
    assert_match "error: config file is missing 'version_mapping' section", output
  end
end