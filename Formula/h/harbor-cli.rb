class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://ghfast.top/https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.25.tar.gz"
  sha256 "e6c79411da79719ac729ff53e6ad2b2e2212f9b81b2dbe01b7c71c81acaa4040"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51b5a735054e963f9fb14870c9c26b9a070254d4f63885f5f3df2c78a856661c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9816bf97fc15832a5eafd3eb0cca3cf485711f75528b8d71d9966240dc12a8e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dec122d798f3ea998d6db9d0b6de85efa1ac6373262cc7a088c35f8d8234767"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6258325a63f8eeffaf72168ac0fe71657eac4ab59fcb30b6d17e5860540b107"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24c6f086abf0f2ab22ebc782459962552c189f45dd65e3b7d220dd2136f8d14a"
    sha256 cellar: :any,                 x86_64_linux:  "b87cdacd4a16a4dadc20bb6d61888b656db68c0eef32576ba0dba4755de8e320"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.Version=#{version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GoVersion=#{Formula["go"].version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GitCommit=#{tap.user}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"harbor"), "./cmd/harbor"

    generate_completions_from_executable(bin/"harbor", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/harbor version")

    output = shell_output("#{bin}/harbor repo list 2>&1", 1)
    assert_match "Error: failed to get project name", output
  end
end