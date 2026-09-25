class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.51336",
      revision: "bbd0b3eb1f6ed4b79bd3c906974bb5334402afdb"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16f1cecceac02ba9135d7e44d8fcbdc1c5a9d6d88bb55b08a2c6ca5ce21da7df"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2e0c9078a4d8a372a6a1514b7548a44c17b76b5f0860a94e1fbd6fe91b969e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7eb360759ae7d78f93c6394c9a2c44df0ec20727b32793ea6748e44e4b658237"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f4279001150c0491d5e55a45b529aefc7fe25f32ad462373187b76367c8b37c1"
    sha256 cellar: :any,                 x86_64_linux:      "8470f6eac1713e99d14a045aa0944c591d5dc092f0eb046ff9138dd17fef5f66"
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