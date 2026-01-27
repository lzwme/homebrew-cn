class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.8.7.tar.gz"
  sha256 "d44458994bdd4bcc3bea2d6ad68c4dad2371923915f235db96c11fb274fbe5a0"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56d669d2c28e4a19d43ca5f4efa7a65d9c8c07de3918e978fd1312f4827f5fd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a793004b5788ca7f751ce0aa2d4e9cd43549375b288354d099c0893a4d8a02c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "664832539100ae31ae26c847ffe657c996d105ece714dc4fd422b5a99fe418d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7e55b4eff01d7808276226cf0bb5a8e117bd8b9d2f7730656aeff3bfebf4690"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0819cd18942726861431a9624b1e35c71263013c46022869633ac7e7b5419fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9937bed42a83aeaf4a212a312af05dc88dd6233fadde1fafe7ad363981a168f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end