class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://ghproxy.com/https://github.com/tensorchord/envd/archive/v0.3.13.tar.gz"
  sha256 "0863ada94beec849e7f0a89db14d088ab50c082a5579e8da525eb7f5f9393cc7"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57c3cf422676e9a73a9697bd589bea9cdb3d7319b8463fe8cde9aae36ad1dd8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57c3cf422676e9a73a9697bd589bea9cdb3d7319b8463fe8cde9aae36ad1dd8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57c3cf422676e9a73a9697bd589bea9cdb3d7319b8463fe8cde9aae36ad1dd8d"
    sha256 cellar: :any_skip_relocation, ventura:        "bb1a27ce1d30a2a79eeecc0e6aa0ecac3fe86fa58aaa65f33acc6e90d50aa0e1"
    sha256 cellar: :any_skip_relocation, monterey:       "bb1a27ce1d30a2a79eeecc0e6aa0ecac3fe86fa58aaa65f33acc6e90d50aa0e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb1a27ce1d30a2a79eeecc0e6aa0ecac3fe86fa58aaa65f33acc6e90d50aa0e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6443a34bf0a1908085d997bf913493b1ed7b5acbc954942776bd1eb11aaf9f5a"
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