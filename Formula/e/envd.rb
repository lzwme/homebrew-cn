class Envd < Formula
  desc "Reproducible development environment for AIML"
  homepage "https:envd.tensorchord.ai"
  url "https:github.comtensorchordenvdarchiverefstagsv0.3.47.tar.gz"
  sha256 "d4d55f516fa5ca1aac68dbbb096a7bafcc09abc46fa27e8fb5472213df7b9275"
  license "Apache-2.0"
  head "https:github.comtensorchordenvd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bef147fa1f3f31e0b56a2102f8c4f8697b0fbf3e3515fc5116367bbe571d70a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84d08797fc2f8a51658c058ec87298618ebe827cd1d8c17ed940daec6e07747c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09c1e1ad73fc6ade3e64b86226dd02a10610e75f2d1b457e653dfe866c01fd4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "acf55882906a1c20541b2fca887dfc73a4dfc952171c2474394c4aea97ee9a84"
    sha256 cellar: :any_skip_relocation, ventura:       "3c8013e537c9c88729c1768158b1e53b7c70cb8c56cc8ca151efe7ab8aaa9b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8cda788a34d6fa52e5fb5b8afe9b9e4569047bc62b22daf02351f2c75bc50e1"
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
    system "go", "build", *std_go_args(ldflags:), ".cmdenvd"
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