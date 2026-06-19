class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.28.0.tar.gz"
  sha256 "b4a3181ba7395133e2a36bade1c49cb2f45431c4a80f76d582f88da018ef994e"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d51e76eb345d0e1c8d7e1a33aebccde2c15a77a77447301d6c531cb0ac015422"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db82617c3c56ed3472f214ef33bc2eea6447ac4ca1d7da3da63760de11a6353c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33fc93dde860523cc36afcc629736567d1ac162069e30fed1840467d5d1f3f7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb59d5b35f30b68ef6bd1d2f970ed657808481f4b38179f1f770fb9a2f9fe1b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9395b77e27e4bf6dc7a91255b4de496309349856cf4360fbb7bb95351a719d7"
    sha256 cellar: :any,                 x86_64_linux:  "9f29fb90a5834a1cf9b76d86480c2d5936cdc37dce1f614757ea94ffc571a7ef"
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