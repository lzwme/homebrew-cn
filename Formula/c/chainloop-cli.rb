class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.73.0.tar.gz"
  sha256 "d77521775ea7fdab680b6be4aceea058998fb62b3e10bddbba4bdbf9eaa74fae"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64bf7ab3e091682b144384290d6b0a4e216e9847f8fddd89a7b30f164bf14546"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fdd9305736aa2986ae02cf854d52149f6f7629455faa30e3ad0aa8cd23b35cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ddd5974bf71fd12b692c8e04ae87b2eaa34b9028b802ce5edbe87e0140aa795"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4ebe9dfd830d738523fc3c7447e03eec4635a4fcba662c38fc1d081d9d06a40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86cb75652f4e4a574377a8b8ab3b06dc6b2d4cfda97faf718cc1f4bc22196a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fa07c4dbe5c637e4b03743e7eabcfb3977db2996976c73265a16202d203c83b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end