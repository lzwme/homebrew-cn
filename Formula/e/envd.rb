class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://ghproxy.com/https://github.com/tensorchord/envd/archive/v0.3.38.tar.gz"
  sha256 "f5bc814b2a9b69b7fdc86116fd2551e9b191492e2a9e64ee1ab47bf4ffd3ddb4"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "353597e8fd7826065fb727e41e6aafc42335694deddd98a12ef27c47ff107f0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed6ea39b7e9b39da0c07a1e58a264d6e7c5fb0a164227770546ae85f53113748"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96ae5b8e814b203e05181dbb7a90307e61c9422fbc7bd05cc783cca9873a71a0"
    sha256 cellar: :any_skip_relocation, ventura:        "876ddea10de996d00a71ea6369134ba1cac9f546865dfa54a8bdd36f98461fd2"
    sha256 cellar: :any_skip_relocation, monterey:       "8f15ce3631a3e0505431a8a7b96a2928a5968a7f88e238e55f727c33b79700b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "474b76a60077d8713b3e7fbd7a039953637f1fa80211bf1107e94bf05d2247c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "632cb921f006940a489a95edf61fde9d70db61782bdc2f729f531da32567182f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh, :fish])
  end

  test do
    output = shell_output("#{bin}/envd version --short")
    assert_equal "envd: v#{version}", output.strip

    expected = if OS.mac?
      "failed to list containers: Cannot connect to the Docker daemon"
    else
      "failed to list containers: Got permission denied while trying to connect to the Docker daemon"
    end

    stderr = shell_output("#{bin}/envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end