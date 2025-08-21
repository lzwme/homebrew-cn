class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "e82f1cf25507360045d61df07ba5423b452f55691130b2a48764bf296c70ad48"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78bc8571adb483b17733edb00908da90b234cc6c1451401e6bb104997204b34e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee8b02582ccc21c1791807073e32af7fc948eb4ffc2d743ef43e1da5e23dba2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61d6ce8daa8aa4abf5d13db3a17aef3e688f1c72f7fc0c87b769a51a5fe5f356"
    sha256 cellar: :any_skip_relocation, sonoma:        "52b16d1d6a4a291664679974ded31d0e437143182ee1bf6297b9b9731de566f8"
    sha256 cellar: :any_skip_relocation, ventura:       "4b0234529923931a77ac80d11300e5ba9b07a9505423f021577ffeaa24d09de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22747b0aa9f2a13ad652827f1000f64822dfa4adb1898f80034b91c1d9d71835"
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
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end