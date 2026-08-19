class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.37.0.tar.gz"
  sha256 "7e19b398c6d15ceaed27a65ea3bfa1fa81b8ff6d67f5496ca7351573916d5e3f"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a599df982dd0f8654c77e13f91d88eb8b610da396bb64167b16c5a786c6ffd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "393f90b0a304cecff48f5bbefa92739cf0f825609a3ece4008ee5de47a9734cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66176f819d2a4bf298b379e07ff3034a5742ed2b353da69761d6eaafb5663dab"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bfb0ae7a2f632e8dc84c94af9132ae305a3c50da584332d63f04ae65f001759"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b472db91d89795a8fbe93a57c755f7a70133db12e9211664fb38624b1c923c1a"
    sha256 cellar: :any,                 x86_64_linux:  "f8689088436f65a08cba323d7ab95771c643f6f8851173be541ffd0bc82b8a70"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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