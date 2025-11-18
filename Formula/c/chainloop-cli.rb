class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.58.0.tar.gz"
  sha256 "3314c6f9e110336be602e3c89d4e1c60dcd969f9e69236ca7cf0e1cc90b8e4e7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "550bb80a2cf1dbe757b4b4222e250dd62d548c70f3da8965583573f2a3521e39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "767339bfd8cdeda50448e17f9eb0b8ae926194d40bdd533454148f7058e7689d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d88794db84acd06dd6c104d9401c59040531d2847147b6ed70c0a3543ccd5d4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "89d173dbe2a365a9abf2d6eee8e115f630f78769f610efcfa63a45c911775b88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52624556a79b247e618d760776e673b829621473304910f421ded1528b55eb72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6685cbcbd5d27f935b365b2e6ecca6d7e0e1a8d9726da6d1fc74961663e3ca18"
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