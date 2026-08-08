class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.47471",
      revision: "c82f24c3bf8c5a01da7d5fd03f7b897aaa19e337"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "263765697b0f4c599ad3644f13ce88f747e06c720027a887cf98d469f1cf5f44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "108d7de0eeca07b08bab83b776bfdbf7e77bd7339de3f3bdb5de9fc550194700"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99aec0120c7c6fd7192001df6231a4e08a25128fe35f436619dc9a4e5c3aee10"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd1d42829651a45451638e46db8e9e3a53b9919fdc117cbe0a6a549a6d278027"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5899bf2aabc969ad73bebbb4ed9c63f7e092e8b8dc9823475047d461676d631"
    sha256 cellar: :any,                 x86_64_linux:  "d5fc18b420897b126d704e014f5e10d76e8a467c030f70fef7ec2592450d088b"
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