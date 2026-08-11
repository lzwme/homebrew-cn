class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.47571",
      revision: "51004f91ccd684b683f897aa0707f62cd95501b5"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd014166205df5bf9e5210c4fe44d899618769c4cf7ebd81e5625ab7756778ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "029a06a77a7ca09b659280bedf52b6e5ffdeb0f6a7e8709502ae7f9885f1be53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1632e61398c66f60b98b5ec269f5fb8c982737bbcdbc855a73814bbf7b38952c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e880cae00cd64d13f9d27671851a9701fd7e9636ed38834d82d3d2d90fd7f33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90553434d99f1e9bfe22d4b0c92ab6312e21f4227dcbf3cc370bf5266c2c0396"
    sha256 cellar: :any,                 x86_64_linux:  "c57ae92eea7a4badaa750d40c347d43da663882928ec2572f5fbedf95ddd8b1a"
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