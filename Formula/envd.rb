class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://ghproxy.com/https://github.com/tensorchord/envd/archive/v0.3.33.tar.gz"
  sha256 "d1b0cdf03c1bf79c96da909e05a982792d7be670b4799a27a9281abcd774860d"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c37cb582bcffcf9c11ce95f46ca49a2e648b2c6114adc6bc07f460b20ccdfec6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1903fd62e3455e2aae85482c43e46ae5d183d424b30562512481247bcb7c211e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2484987632b3e32d050a535cb0d783d098c6ed9c52c85bcfa085d63c41df4e1"
    sha256 cellar: :any_skip_relocation, ventura:        "358f9d6159954ad0e24765f74ca8e9c33d6d7fa86641109788c3ba0bf52d6440"
    sha256 cellar: :any_skip_relocation, monterey:       "b2b878ed0945d685a28dc71fb93f1e4abe178d624652c7c0597eca7e01a17a3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1b5856b2cd923cfa2059b488b7fbd4e0aa31e82ca2c5f67bfd4fc5292f7a62d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6929932ee3894104b73de3af625d01549a3aa4d0e881f9d02687b5a153d8f85"
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
      "error: Cannot connect to the Docker daemon"
    else
      "error: permission denied"
    end

    stderr = shell_output("#{bin}/envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end