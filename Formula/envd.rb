class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://ghproxy.com/https://github.com/tensorchord/envd/archive/v0.3.31.tar.gz"
  sha256 "057a48ef6e478cdfa7c8644acaa660c5b6bb5db7d5883f4d3f70fbc3459c7a5f"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b47aa266486641721e6cb16ef405a9c826304a6068c3feadb4ded6a4bfeff25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b47aa266486641721e6cb16ef405a9c826304a6068c3feadb4ded6a4bfeff25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b47aa266486641721e6cb16ef405a9c826304a6068c3feadb4ded6a4bfeff25"
    sha256 cellar: :any_skip_relocation, ventura:        "f5e548f64c12f39fe09a497e4cf99f383e45c7db65e32abea0d4068d1bee6ade"
    sha256 cellar: :any_skip_relocation, monterey:       "f5e548f64c12f39fe09a497e4cf99f383e45c7db65e32abea0d4068d1bee6ade"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5e548f64c12f39fe09a497e4cf99f383e45c7db65e32abea0d4068d1bee6ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32f88343daf9e00df3551d3298812a8d1cab2ced24c87e25b1a872b6f92009e7"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{version}-#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/envd version --short")
    assert_equal "envd: v#{version}", output.strip

    expected = if OS.mac?
      "error: Cannot connect to the Docker daemon"
    else
      "error: permission denied"
    end

    stderr = shell_output("#{bin}/envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end