class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://ghfast.top/https://github.com/fastly/cli/archive/refs/tags/v13.2.0.tar.gz"
  sha256 "fe8b7630efad5232273550d73783f5149803e39b9cd385b17f904db8468a870d"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91d8f1b856f71c1430491f35984da13a3456c67f107d4910f88d677b519dacdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91d8f1b856f71c1430491f35984da13a3456c67f107d4910f88d677b519dacdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91d8f1b856f71c1430491f35984da13a3456c67f107d4910f88d677b519dacdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "06e2eb8661b70e2284ddf2ac4ec4653dbb10370fccb269f661f2d20b07568b9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fed1b129285b62fa8cf6e0e306f2b8e68f9b119acae26b84762bc5ba536fb3bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16c14fdcb12d815a01bbbce5ae7444a56cc0037f0ca7afe492ce6640f888673b"
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