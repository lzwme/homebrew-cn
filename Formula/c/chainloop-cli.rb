class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghproxy.com/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "050d712e27ae0364a1a043c891f8118827c7d918a626507c23a9433fe2993ffb"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9eb86cecdf24e77e3b8189e1188b9906277b05c97c45e143a002d10eb6ee70db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ae744c319f12a0248a709a8a13357c28e28d1b601f3ab1fd94c4905cb583704"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78edd7c8925cce6c9a8d63733715875a5e74cb73556ebeb28cb2ff7e11c9e16c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f3f1532a1815250a4144f0ce1b8964a5fbdb8a1365211a57a541d9a13763102"
    sha256 cellar: :any_skip_relocation, ventura:        "99c183f98c0c7b30007bf435d106c8ed06e27c2e8e55dcea561d6361cb3c7ba4"
    sha256 cellar: :any_skip_relocation, monterey:       "d2fb9ab382e2748f9e818f75a8eb8c53427e44c752887a2766d302bdeb69e4fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e47a5f8a4b68b0348d8391ab9e5db540167cea390b7f19d72ea8bf9dfba0f8c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"chainloop", ldflags: ldflags), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end