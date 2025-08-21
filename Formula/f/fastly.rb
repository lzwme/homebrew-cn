class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://ghfast.top/https://github.com/fastly/cli/archive/refs/tags/v11.5.0.tar.gz"
  sha256 "35b886586ffe5a8ccabbf08cfc249836b325a4b1e7c12c6dd5a0c15bd8c18717"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb9e0604ded9cf5029a0d2d512210d772c820ad6ce7885fa5991840bdf25cb4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb9e0604ded9cf5029a0d2d512210d772c820ad6ce7885fa5991840bdf25cb4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb9e0604ded9cf5029a0d2d512210d772c820ad6ce7885fa5991840bdf25cb4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c914d3b92394c8c5678beaecc1dcaeaf216f2d69f27f1206db8c95a67c3e9897"
    sha256 cellar: :any_skip_relocation, ventura:       "c914d3b92394c8c5678beaecc1dcaeaf216f2d69f27f1206db8c95a67c3e9897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ba0777ecda7f362410ff556e980267327b4e91b069c37464a038e24a931fe34"
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

    output = shell_output("#{bin}/fastly service list 2>&1", 1)
    assert_match "Fastly API returned 401 Unauthorized", output
  end
end