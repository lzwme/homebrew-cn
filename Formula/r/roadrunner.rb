class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://ghfast.top/https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2025.1.8.tar.gz"
  sha256 "bfd0bd9194dda9abdf801e08391bf8612f48fae0711e9666585db7a8de89209b"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15b363ad65b815275959e84d8cd26461b269082911b926a2a906e2051aaec4b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a204357f57e1b40a17824caf40542522ad1c8dabc2c10966cce63bf65fe66233"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0189c13cf869b0389cf2c72cf4d294ac5d1928a6d768fed472be644577cda126"
    sha256 cellar: :any_skip_relocation, sonoma:        "edffd14122adeb2d797ef4598180617e6e85a4d3c540eae53d31702872a6a05b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d8d6f6f1d77cf76745139f4ee1422064736eed0d96cf6e3439543bd9c0ebe38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "660ed163a724ed704069f39206316f971b138fe80981316cec6a781b6aa7c161"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "aws", output: bin/"rr"), "./cmd/rr"

    generate_completions_from_executable(bin/"rr", shell_parameter_format: :cobra)
  end

  test do
    port = free_port
    (testpath/".rr.yaml").write <<~YAML
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp://127.0.0.1:#{port}
    YAML

    output = shell_output("#{bin}/rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/rr --version")
  end
end