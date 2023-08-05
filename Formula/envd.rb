class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://ghproxy.com/https://github.com/tensorchord/envd/archive/v0.3.37.tar.gz"
  sha256 "f388f097a503bd9b9c16176ae10bc67c105479a80a251c102abd98fe0aee5255"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0e0ef2a33ff13505efedd1c0917d9c16cd27c76cc8014bbad9bc92799478858"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cddedeb1a91b3dea641671868f4db0e637a00b22e42e2e9db43eae85035b135"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b67096afedaae027d977517c8735641725c691dab18533b6928b1aa9c7750d00"
    sha256 cellar: :any_skip_relocation, ventura:        "58de9b91c7afc2f9ed2e38d9df09d02a730970cafcd26dad3aaca43d5d700d6f"
    sha256 cellar: :any_skip_relocation, monterey:       "ccb5989d000c993b8f140c9173bf2ee6b8056f7281d4157565a10b4ab4cf9b3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbc37f67918e538289c58f2b7cbb9fe6fce0c4f082de086c713b3dc4328484ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ca26caf8e14dc9fffdfb7e93d4e81769b37f3ce0e4f8b0cdd52f36dac104357"
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