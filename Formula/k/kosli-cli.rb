class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.23.2.tar.gz"
  sha256 "68a79ac463683a5c078faa1724061f28d52800438648a1c3cb92f0374a8132bd"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e249caa53ccc9f5aefd73348cfdc1876d88099884110b0875e8356f73e389fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90659709a92263072fc39014d551689b4a5f34806694ad552831877959a5ec97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee0aa08545c64285d68c2af8014e6e2455435bf3961b93e7b406dc476aa0f78f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d1ca7df36654eefb6ab27c7c7b76d3afe168df7617cdc006a115cc184ee3b9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe890043d9d25ad36ab67eebd7d6b255bf46dfe67875e29d3e6b78a05533e45b"
    sha256 cellar: :any,                 x86_64_linux:  "b4c5df396600322c9742c9ecbea0c3ea415d71f3174d74408a61f7f7c9754de7"
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