class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.47993",
      revision: "1121fafe77b5b2bfa623dda1a244517ff604a823"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1aa48b86e5d995f763c8489afb6b9b537f34eed398f2fc66b8b81747e751eabd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eb0be9875f5d9ef8e45fb9fcc44a49a6418c6116aa8496dba2b2da864e531b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "641a0bae25614d8748135eff7b7703ada3e232595561a276646d9bbec80c992a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0144bb67bc7ff0fe861b2edaa32e41d322e6af805c5d9dab9b90795857d1814"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4fb087087d13774aba233c7a78ff59c807864b3343180671acd0bcef8144b1d"
    sha256 cellar: :any,                 x86_64_linux:  "9c5af6e0cbe39155cbc0e6262d4727ddf212f5f75933bc13b85308a4e7eb86de"
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