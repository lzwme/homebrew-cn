class Envd < Formula
  desc "Reproducible development environment for AIML"
  homepage "https:envd.tensorchord.ai"
  url "https:github.comtensorchordenvdarchiverefstagsv0.3.44.tar.gz"
  sha256 "24ec986b5f720196ff089c49568ffc6f70e2800dbdd7c5edee3d28c3d286cb6c"
  license "Apache-2.0"
  head "https:github.comtensorchordenvd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53b3a07fd6468784284c3d5cdf1f2dcfe2f67e265cdfc6a9f1d47d922fa74682"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14a535b5acb04b2fc647e1d7cdc5794953c0c99a95a03da372189517176ed5d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c06957d03c7e9c5368a6738af6292d4c162bd3f485e8c665fefd6eb7ec2a57c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "76f40991f455063bc9605eb6f73b948a1e2ca8085a90b27105e48e2a694bfa35"
    sha256 cellar: :any_skip_relocation, ventura:        "437bf7a490bf58d3a1c2046667cae0ed37427a43858f5678df123d4894af6153"
    sha256 cellar: :any_skip_relocation, monterey:       "338816b03aac0f635d0cb02536fdf93dc1a28caa8b81c86d9dc718ad0ffab782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dca9b73d7ccfcf878e85c1f49d9359537fe42e59e9870947f8913cd95a86d5b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comtensorchordenvdpkgversion.buildDate=#{time.iso8601}
      -X github.comtensorchordenvdpkgversion.version=#{version}
      -X github.comtensorchordenvdpkgversion.gitTag=v#{version}
      -X github.comtensorchordenvdpkgversion.gitCommit=#{tap.user}
      -X github.comtensorchordenvdpkgversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdenvd"
    generate_completions_from_executable(bin"envd", "completion", "--no-install",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh, :fish])
  end

  test do
    output = shell_output("#{bin}envd version --short")
    assert_equal "envd: v#{version}", output.strip

    expected = if OS.mac?
      "failed to list containers: Cannot connect to the Docker daemon"
    else
      "failed to list containers: permission denied while trying to connect to the Docker daemon"
    end

    stderr = shell_output("#{bin}envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end