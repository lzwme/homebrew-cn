class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "de8b335602c6ea3aa06363bf3720056237b4c64028be65cc809d108ede8fb480"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bd5cd9d7798bed706fb1987b31ce011c38c897f83fd0559c82bf58355340de9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc0802634bcb60bc1a21b345eec5446af51bd353da201229f9667e797e632fd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24a38a57af02d6356e7adc92ce8f6d89b8097bc28be2c9caeb247c1cdf460fd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "30c5adc0c636aac5344b4d19b79633c2db4bd76d6e8bfac0b614a7cb0cd355e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2b176b1aaf26bb43f470c30c5f9edab660aeeca602d32b52bfc66aa2d011a0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f79ab251679e508bea5b258510eb4cd4d8e42e8891b95fd57490893420618230"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/cagent/pkg/version.Version=v#{version}
      -X github.com/docker/cagent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match version.to_s, shell_output("#{bin}/cagent version")
    assert_match "UNAUTHORIZED: authentication required",
      shell_output("#{bin}/cagent exec --dry-run agent.yaml hello 2>&1", 1)
  end
end