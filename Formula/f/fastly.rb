class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://ghfast.top/https://github.com/fastly/cli/archive/refs/tags/v15.6.0.tar.gz"
  sha256 "e7f6d44dcd901fe044501c917748e8e35c2377c2fd55f37fccc2e9007bbc0c1a"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c8e149d5ea94d0e4c3b4dfd36ed7720d05214ea6ea9fbdaad8337d0e6905780"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c8e149d5ea94d0e4c3b4dfd36ed7720d05214ea6ea9fbdaad8337d0e6905780"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c8e149d5ea94d0e4c3b4dfd36ed7720d05214ea6ea9fbdaad8337d0e6905780"
    sha256 cellar: :any_skip_relocation, sonoma:        "0677ac38acc8a98a2a343b313c8083eb61dd360cf331b1b3d12db2d0d6ff943c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c66a6eecc4f805b5d87cd4415c1d060f24ce037775ff3b3b01d9b9fd02424ca"
    sha256 cellar: :any,                 x86_64_linux:  "621d8bad85559ee730e294f00a0896120c564d38b4128f2140bf997936f7e32f"
  end

  depends_on "go" => :build

  def install
    mv ".fastly/config.toml", "pkg/config/config.toml"

    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip

    ldflags = %W[
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