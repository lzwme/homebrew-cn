class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://ghfast.top/https://github.com/ForceCLI/force/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "f552f341e0d98ef2e6a5d470a7be2c1655815f08006d9df6691325bed181045a"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c1fb2395fffa2fb586f2bf24ee0856fdace37a7e85763fcd2860424cc17d51b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c1fb2395fffa2fb586f2bf24ee0856fdace37a7e85763fcd2860424cc17d51b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c1fb2395fffa2fb586f2bf24ee0856fdace37a7e85763fcd2860424cc17d51b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6530587802fc85fd000be628282c2e4193531872bd62a6279a772f4ff3170b07"
    sha256 cellar: :any_skip_relocation, ventura:       "6530587802fc85fd000be628282c2e4193531872bd62a6279a772f4ff3170b07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ca79692265d7b73ed6a99221905abc3a4666a823ba6d0d124aba50ce606616c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", "completion")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end