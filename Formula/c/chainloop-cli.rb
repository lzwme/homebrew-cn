class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.47.0.tar.gz"
  sha256 "997359c4a22dbe1825caea1633fc6a897cd5b289eb9e3b2df628c0e094e31226"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "649f3553565ceb4ae98bb6b5d2bdd8a447ccc4a2b586c52aa4de993df411f0e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84283266d3331c44c3c632db46f7eacdb3edd56c3a809a5a19d48c06d0206286"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "670d9f8205cd89767a3416044318026eb8a0709bd9d67abcb33c064426e01d14"
    sha256 cellar: :any_skip_relocation, sonoma:        "375e12c289edea673723d5d9ac996ff661cbd99e4f98b27d9a58bc2ad5cefe1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e5b61680d187ac2b0169de0b64a62ad17689c33f7477e1453f20e85ebb9a66f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8727e54daa99846ade862a2f5aed1478750cc88e0437f19d76b18b99452bdd28"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end