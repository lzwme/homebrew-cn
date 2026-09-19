class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.50757",
      revision: "cacfc122bd46b6fce8ef4fcfcd8f0ac0c9a5a77c"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8450aba637635bbc8737735dc4f24d4e998b78dc98531aa852046eb2f71696f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "734f76dc23dd505509c294223c941c03b537985e95fd2c189b39466160d98e55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "933205245acf8d707c5f9856cb08aa9c6d36ca6955a5e9ab86c1d18b31f5728f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "00ae7c99ea3425a9974d7c345857ec46f102c78c5052b88349fbbc5336a44c42"
    sha256 cellar: :any,                 x86_64_linux:      "8341f22cf1573223151ee3ae7bdb9fefc3528d93c980fba8185d09b7e2baf44a"
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