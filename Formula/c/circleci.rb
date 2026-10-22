class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.11.0",
      revision: "cee1069746711d2ad71d3231bb83103f04f364f7"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "20ab393539b2117fb950600a3224726b8a9d9c93063a7d77a944c707a8113280"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "00358e8469010ad98ad1e56b573e1df7c0e79890e5e139d5b72ba20b8dffad96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8fd5da92bcf2519dc37d2ef1af0943326af25fdfd903eb79d0b0a7ac2840041"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6f960568ec63fb596a27b4c349659789343e4f7de802d94f281a59e7c9507cd0"
    sha256 cellar: :any,                 x86_64_linux:      "296b80650731a5c60730e34a3ad852e4abff5663947a931fa05da9074e1245ff"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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