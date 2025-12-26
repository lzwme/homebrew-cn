class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.36.tar.gz"
  sha256 "6b818e3f1ed7452a7488fefdb6d09664a1f1a9a5c35302634836be1be38f9536"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "093a628bd89baca47cf21887ad6f3c64b96cd8f177a53329e521cb9e92322efa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ffd3f1891e9d93eac315b4fbe56d9e5b9c1d54105ed29c6216619e24d7ee344"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b634d7e8df04672625b1a9fe5716a837753799ca89172d701db490df46cba78"
    sha256 cellar: :any_skip_relocation, sonoma:        "731068c2c480f266d8e999bd5583991384650e927e083e311bef9364bc477b1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "751ff3e048d3e2d21f246036f0e61e77f67a4fdfb073658d377cb1d416e75ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69b3c98358c8ec3a91b157d6234bd71db39d9a9840224bb078b5d1ed2cf5f3fa"
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