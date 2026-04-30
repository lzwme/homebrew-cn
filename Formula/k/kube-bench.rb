class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://ghfast.top/https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "4958d5b9a51d22879edd1c3ea6f7a0f26f3b5318cfbe19bde8b3f04b9028d6ec"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e19ea531b5b2ffbf1c79faa2a87aca0ba4f8e6ae2cb2b6653d50f94878844ebf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e19ea531b5b2ffbf1c79faa2a87aca0ba4f8e6ae2cb2b6653d50f94878844ebf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e19ea531b5b2ffbf1c79faa2a87aca0ba4f8e6ae2cb2b6653d50f94878844ebf"
    sha256 cellar: :any_skip_relocation, sonoma:        "6354115036f84bfe2b918ec7ee6acbf655aaf5416cdeee8617377d9d615103d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "281a6ee78611f3e04640cdca0e75669fe74e3718c79edc5f8281383b06c9fa39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "797505add0dbfb86222e101d7b53b518fa410d1c97c85872f23300e4d1d54b6f"
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