class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.4.0",
      revision: "6d63346d9d6df34f560b1370f641af8099050763"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "887c71064dc7e08df97270f58bac4be0e53dd51240ddeee327bf60fbacca75dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb6f5a21a4d0a6fbf7cc1fa477827421abe03652b39aae08ccd6e1bbb397e244"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "258883dcb4d7250b7f2c911c1e179a1c60949d0d1232d416af5a2f2537a13f89"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c6663e64ca9956d5f45df7fdcbfcf9b5ecbc2c7955b4c3695d21b99817125516"
    sha256 cellar: :any,                 x86_64_linux:      "b21c8c4393d62cb2e19f9bb34a525983579a2fb451509f9ca6bbbb605b896cb8"
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