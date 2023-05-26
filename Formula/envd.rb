class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://ghproxy.com/https://github.com/tensorchord/envd/archive/v0.3.23.tar.gz"
  sha256 "aee63d2bf613b0db8d3509245885023d380cde56cb21da68d905dfdb672262f2"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "520e71941b3fc96fcbb566c4fa76b288275cafdbd98ebc668a57a1ab5331fec4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "520e71941b3fc96fcbb566c4fa76b288275cafdbd98ebc668a57a1ab5331fec4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "520e71941b3fc96fcbb566c4fa76b288275cafdbd98ebc668a57a1ab5331fec4"
    sha256 cellar: :any_skip_relocation, ventura:        "c6cf58000e1222248c0507d5a9de8f34a790b654f38f60f5b818443cbd8f850c"
    sha256 cellar: :any_skip_relocation, monterey:       "c6cf58000e1222248c0507d5a9de8f34a790b654f38f60f5b818443cbd8f850c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6cf58000e1222248c0507d5a9de8f34a790b654f38f60f5b818443cbd8f850c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53f52aa13940d92c212908b159c2c79468cc1598db8a9946ae48bc700c55273d"
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