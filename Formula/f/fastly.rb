class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://ghfast.top/https://github.com/fastly/cli/archive/refs/tags/v15.5.0.tar.gz"
  sha256 "7d342e156d10892e9afb7b8e197776d9a0af5e6f9e2d017c1367803a954dcfad"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "766af90a67617910b8c31ca3a79f9e89ccedb02288bbc92eb4fd69b703525f7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "766af90a67617910b8c31ca3a79f9e89ccedb02288bbc92eb4fd69b703525f7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "766af90a67617910b8c31ca3a79f9e89ccedb02288bbc92eb4fd69b703525f7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "49e48c5fff4b7e300016aea1fbc051386d3bc5ab1d118b0920e766323481d8b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0caacbb6a41bb3f93f8a25218840d41e2318d4254f53a57899a832a28b429c35"
    sha256 cellar: :any,                 x86_64_linux:  "a6c86a7a2da00adb62d70edf96f0733420d67308bf8ed1d087c2d1f1ac9f5374"
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