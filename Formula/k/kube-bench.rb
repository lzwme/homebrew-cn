class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://ghfast.top/https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "30ae4e876a05f6acfe783034079a347b6748d4068ba4b7e340376e2a50d9112f"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7990926e12fcfea7de74fbb64654c2841788fd5a5086a8ee8dca97c70e2f3f1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7990926e12fcfea7de74fbb64654c2841788fd5a5086a8ee8dca97c70e2f3f1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7990926e12fcfea7de74fbb64654c2841788fd5a5086a8ee8dca97c70e2f3f1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "45e1eebbb1992ec62485e039fc975f2a1c8e514690c98b063a4c690541c272bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fd7cf9df6e8d167d55327dde8eee30bbbc7e276d4e0ce70e858a364304f056d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55f1cbcf44bc96e573729758356b8881b9997ebdcce9f381777d3ca063055d06"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/aquasecurity/kube-bench/cmd.KubeBenchVersion=#{version}")

    generate_completions_from_executable(bin/"kube-bench", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kube-bench version")

    output = shell_output("#{bin}/kube-bench run 2>&1", 1)
    assert_match "error: config file is missing 'version_mapping' section", output
  end
end