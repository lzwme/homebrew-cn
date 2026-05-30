class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.22.1.tar.gz"
  sha256 "91bf5ca71d3d85bd5a7146340d36cb7f318acbbfe52b179af4dff1317a3e437d"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74055ae9a89cf7f433a5865c79d82961f2d2fc05888b6582165188df951045b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bdbb456f231fa6a92bf26d5edb95a86f51967858ecdf09c6b89f9b3ea145bdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04512749fb739d1e16f4b63140b2ae8d25add83a62d0e2692e7a82115485a2db"
    sha256 cellar: :any_skip_relocation, sonoma:        "64b4d14d38e28aadf552e83747e229557f6c5c7bc21926e11d98c31c07d04c38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41accf9393c2fed80ad74ddd292597ee564b46f0543af79b0efcc8a2b33872aa"
    sha256 cellar: :any,                 x86_64_linux:  "6ba182573ca7077c2c8226a489e6224c493bbbc15b8e9c11cefacaad2b49316c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end