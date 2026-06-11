class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://ghfast.top/https://github.com/fastly/cli/archive/refs/tags/v15.2.0.tar.gz"
  sha256 "030b48149ac44f5b82c5533e006b98c8ea8dd5d84c90fe70a0e43d9a39d96adb"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a81386fb20fb11900b24b242645f5807b7100cd4c4336f64fe024961d4d55289"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a81386fb20fb11900b24b242645f5807b7100cd4c4336f64fe024961d4d55289"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a81386fb20fb11900b24b242645f5807b7100cd4c4336f64fe024961d4d55289"
    sha256 cellar: :any_skip_relocation, sonoma:        "407408efa7bf7b2dc8a87c6a9884ea1a2aaec9ddd6209b616f02ea224f95c0b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6599d6a831710d8af8f8781817e165cb2912cce60fbab44314ea49e97fc216a3"
    sha256 cellar: :any,                 x86_64_linux:  "97e1a15924a3d42e5504b4c5702f81d8b75fe14a5b9a6d05c7a7f3af11dc8814"
  end

  depends_on "go" => :build

  def install
    mv ".fastly/config.toml", "pkg/config/config.toml"

    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip

    ldflags = %W[
      -s -w
      -X github.com/fastly/cli/pkg/revision.AppVersion=v#{version}
      -X github.com/fastly/cli/pkg/revision.GitCommit=#{tap.user}
      -X github.com/fastly/cli/pkg/revision.GoHostOS=#{os}
      -X github.com/fastly/cli/pkg/revision.GoHostArch=#{arch}
      -X github.com/fastly/cli/pkg/revision.Environment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/fastly"

    generate_completions_from_executable(bin/"fastly", shell_parameter_format: "--completion-script-",
                                                       shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastly version")

    ENV["FASTLY_API_TOKEN"] = "invalid-token"
    output = shell_output("#{bin}/fastly service list 2>&1", 1)
    assert_match "401 Unauthorized", output
  end
end