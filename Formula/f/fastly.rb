class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://ghfast.top/https://github.com/fastly/cli/archive/refs/tags/v14.1.0.tar.gz"
  sha256 "bc6f82a71812d1a6964c321a94a9882f4cdd8b21156e781ed78946be794651e6"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b97ed23144c87ed834d663c8f99132ed38202c8424a04baf40973d8130cb1b7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b97ed23144c87ed834d663c8f99132ed38202c8424a04baf40973d8130cb1b7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b97ed23144c87ed834d663c8f99132ed38202c8424a04baf40973d8130cb1b7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f34100877b7b339eb434c51c7363aa21e592875c894d5d931f9db2a6621f249a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db4db5d35e819cd4a7d55e0b5f495fb6b51e95d73c61f4858af4ea2026b8a3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9068e8c317765b98d557105afde706648e8db989c7edb10cfdb3a052cae42636"
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