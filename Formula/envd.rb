class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://ghproxy.com/https://github.com/tensorchord/envd/archive/v0.3.35.tar.gz"
  sha256 "91b5eea98071f5e1c74d0c329b85c9467dcde2fb5810b00d6cef71be42b35bf1"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "202bca0f0c554bc1a2ebb0ee4ef5d8c64dff5283ac463dad7beeae6eb428a10d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67a002be25a326680b8d4cfe42abd9e80ca93fda89e7f5047f2dc121e2c8c0d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "403bf21f48898ef4416c9010e301ff1ec2f9ef9d1619a40c10934948e0cd89ad"
    sha256 cellar: :any_skip_relocation, ventura:        "6981bf383460e6b5f6abd74e3880b4aecee8850725278a2ba906f231ebc6b4a1"
    sha256 cellar: :any_skip_relocation, monterey:       "e81133e41edb1d9f9d65239f580fbd48d6aa75ae15820285dccbef45e5cb19c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8f3de4a28373c799787ea3ab78964c27d73f4b4f76958b9d6e50486793ac21d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c92051e21fc5294155a0ba33ebac72f83f0eed9ed18d5ab4309d56dcc997a898"
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