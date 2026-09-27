class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.51515",
      revision: "a2e7dd1c5b90822bbc408655ae23b840d8d46ca1"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4d3c6199261c9bcf4d9f167d00c425e5b16c8e99a7d676d5e143cf24339f8026"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3bb600bf41555ed4faf3132188dd1db24ac0275b7a5322c6d000c5361dcb65c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8976e2c7a218876857e3ef1dca92a3ce1280c76f5e5a713d20e587fde1ecf715"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a801dcbae971768a98e787c58f1d8d4937c626de1e2d26fa08b0f0f15ce67c8"
    sha256 cellar: :any,                 x86_64_linux:      "5d5d7290fe3b1c1a7c5bb2c8a2054415163c42f1fe31c4e5b5d6579e3abb6347"
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