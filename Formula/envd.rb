class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://ghproxy.com/https://github.com/tensorchord/envd/archive/v0.3.18.tar.gz"
  sha256 "cad28aa40ee43cab39df296cc5d603776a09f866b54d2c9b03cac4a0197d114b"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0feb30625e4ecabf4af8cbfcf33c514c6305b55979f2e2a9a046da703e66097"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dca87345d831c51acb14dc22d83aca7db65e7a9d1f0af0870f75116f639946a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6613d94da3f9387d9e0c1b33ca472957ec9e0828cd4acc4a06ac3c247a85c711"
    sha256 cellar: :any_skip_relocation, ventura:        "3a7362bb3b1c05f9f57bf219a48acaa7db82b1d7baa280a942ed97996032546f"
    sha256 cellar: :any_skip_relocation, monterey:       "c84dc9cb3ad1c76d2d31b3ea8d2bffadc16946ae094925e1c46295d05793db05"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc0d162a46e3f187be3ea24693529a089e8c57b313992e7c57b038ee4acdf301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8b1b5b025db437c1d635d3916b8f93d8bcc1173f710099801d7d78bee6ae28f"
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