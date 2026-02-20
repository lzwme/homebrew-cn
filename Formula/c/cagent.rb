class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.23.4.tar.gz"
  sha256 "62f8b8db13a0e6264321463d2ff268f96d9515b97d17f9f545504d2a387a021b"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a61d08b4ed0de4d11daf24c48a1368f1e71a045639796869063b7320d35b4570"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ac41ab40572eaf35c7a30982990b2766502ac8f7fd2d7ce7f4aa0331681d7ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "502e15b3976df5c47788bea2bfa52d7e4bc70f49f3a613d17c954ef5cb4fde15"
    sha256 cellar: :any_skip_relocation, sonoma:        "011e846036caf747317a2ad37b7b84a3150d139058130af8d769d6e6cda33c60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6960a32e76bdf692bb976fe1a5b59df9e6e93495ddd612693bd6a7c7580d0432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d47712bbd5f6879856437554f8c2c837a16f7a4f65eb02134c021bae42b45c1a"
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