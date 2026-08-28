class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.48840",
      revision: "b17071e6f06a269c943c8cab0d2c95a27bac4595"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21c2d9f391c86cf7d4dca0e08ab7b3a3010c189a0f51d2028e1fdf8ebb2c33ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "516cb0e7a9cdd009e35bad889ebb33a1f7ab96ff157237d217e4208bb387e794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a42741834f284425902d40dcb01ef8866521471172f75ea0b80cb72cd9d68f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fb2bb65cfbab2ed557401706fd39593f2d1fec19740607dc22fb625d6f3416d"
    sha256 cellar: :any,                 x86_64_linux:  "5db5978c1595fc39efc90f4fa7eeaf61608232e6489bb86e2c29e02de9e6c143"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/circleci"

    generate_completions_from_executable(bin/"circleci", "completion")
    system bin/"circleci", "man", "--output", man1/"circleci.1"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    # assert basic script execution
    assert_match(/^circleci #{version} \(\h{12}\)$/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
  end
end