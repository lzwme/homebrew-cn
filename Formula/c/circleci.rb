class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.50068",
      revision: "9de7e611f83049938ce9c59d9a448b8c9930f517"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7efd4a5cb002ca71b847425224d984d79cd57e3ff01bf77ba11bc5077d9998ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "33a5d010d9089210c23d23a16649a0b07c209471e1607ef339a4b8315be4197f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a4ae0b789aae1aa6a8a252774f5c711f65b10a6fea3c30c319762aee939f5f0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c549eb131be3374c05a29cb7e3054174f1bd1dac49052f8a6e18c3844319bb64"
    sha256 cellar: :any,                 x86_64_linux:      "b66155a160aa2ef76864ff78b430125215265a8a85cbab40dd6b0b9d085cbbb7"
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