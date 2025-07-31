class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://ghfast.top/https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "7a63e91ccc1f97abe74028632b89d8455329b34bc7c13d67ec4ed8625ff496a9"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c743b646d16b2dffd94c4c619666e678d8a30468b6d39ca05ab92c61de201a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c743b646d16b2dffd94c4c619666e678d8a30468b6d39ca05ab92c61de201a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c743b646d16b2dffd94c4c619666e678d8a30468b6d39ca05ab92c61de201a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "93a456c35e182e2caa745ad873530195bec0ef04d21ba4dea51b09fd42e23c6f"
    sha256 cellar: :any_skip_relocation, ventura:       "93a456c35e182e2caa745ad873530195bec0ef04d21ba4dea51b09fd42e23c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "196e5e2613257c518ab015060354493ef45d9b15ff489a8cfb577b7b2ce9be1a"
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