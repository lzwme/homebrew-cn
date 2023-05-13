class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://ghproxy.com/https://github.com/tensorchord/envd/archive/v0.3.22.tar.gz"
  sha256 "d426fe2e81aa581fe91584c5a971129cf532e8a078f27cdfe71bcf1269601a01"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "774b064ed235089038b727c0dee5049a0ef3239144748a2156405cab9735c08a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "774b064ed235089038b727c0dee5049a0ef3239144748a2156405cab9735c08a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "774b064ed235089038b727c0dee5049a0ef3239144748a2156405cab9735c08a"
    sha256 cellar: :any_skip_relocation, ventura:        "33e9ed47963270db3ec7e69e0f4bff3c3e0ab307ab6e2e02bb7ea2c0b30566c1"
    sha256 cellar: :any_skip_relocation, monterey:       "33e9ed47963270db3ec7e69e0f4bff3c3e0ab307ab6e2e02bb7ea2c0b30566c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "33e9ed47963270db3ec7e69e0f4bff3c3e0ab307ab6e2e02bb7ea2c0b30566c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e876a7a8da643e458e5e7f9c7adbd3bd0620d312907be4a2a2409924c411e08"
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