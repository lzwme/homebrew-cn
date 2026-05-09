class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://ghfast.top/https://github.com/fastly/cli/archive/refs/tags/v15.0.0.tar.gz"
  sha256 "394f2400bce26a93c278a955ce6d3571420c9eda712ca198253468b829f3bcbb"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4eb0d703489cbf5b6a44456f47b8f2fa83d7106b7445c9ba202b26dafa3bc9a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eb0d703489cbf5b6a44456f47b8f2fa83d7106b7445c9ba202b26dafa3bc9a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4eb0d703489cbf5b6a44456f47b8f2fa83d7106b7445c9ba202b26dafa3bc9a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e061183d558f57ba601c7895cf8d1c8b76ab78da593b26452bf0312643c135a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2d8733efe6a4b2ce37ffe8f23c2f0776ca77997231eaa7ea1169d54474fa5b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a52639fd45b034b75f18afa9c5a9b4565f4620c3a54b93fcf60e5d5c9a9c8707"
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