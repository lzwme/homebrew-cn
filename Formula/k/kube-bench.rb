class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://ghfast.top/https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.15.5.tar.gz"
  sha256 "c2332b952b452eca23e4c648b97e5aec3b17edc30dee82a938455c3730318e12"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b43a2bb3c55eae857c3c6c5cbac142be623e77340341828031e44d8d3f950ac4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b43a2bb3c55eae857c3c6c5cbac142be623e77340341828031e44d8d3f950ac4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b43a2bb3c55eae857c3c6c5cbac142be623e77340341828031e44d8d3f950ac4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e55b56a0e92f416b8bae9c59802152e3998540295c8bd110973a4071ff66f91b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c02b0aa6722e528a7134fc1cc3dba15db869fd7c94b80c159f8790550c37ecf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3591cecb211fc7fae05f81b100e9286ed3eb65f14fae14e96299c30befd7475"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/aquasecurity/kube-bench/cmd.KubeBenchVersion=#{version}")

    generate_completions_from_executable(bin/"kube-bench", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kube-bench version")

    output = shell_output("#{bin}/kube-bench run 2>&1", 1)
    assert_match "error: config file is missing 'version_mapping' section", output
  end
end