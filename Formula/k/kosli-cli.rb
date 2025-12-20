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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "146f43487905684ecd89ba157d942dac2f42cf45326beb55376cf84bfe07f43f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85d058b5353b27e9f4a05657adad030dca23d16413a8825d39bcaa486c1ee67f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8482f6169247fdcb420395e4799ee89d08cc07e71e6438218c6d3a173aa482a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0103cda2fe4eccc364e60fb64e7bc8a9f9cbd6ed9cd8d3db254dc34e35ee6d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "017341c1d42c4e371d3e42bf58c3e95a669486975d2f1d373436c687e0780ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4172a2e6b351fc26423cd75ec67766d70accd2106cc00f70967047a87dfceeaf"
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

    generate_completions_from_executable(bin/"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end