class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.49012",
      revision: "3bc297635b4d9ff9060f13d6b6ff437e660cccde"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfd4e2daa1ead004764fc1d878dba969fd2e16fee28232f1e0c289f456aae3af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8210f3e4bea45812bb2f931bd4658cc56065d5ea17a7d89537ceba14d291efe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9807649a181060f6055635e4ff99eb18bc0231e6b31948a012bafcffae5a8e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19980354f6d00e4574706870e377fdd5ba3eeb5010760f81c7ff046150bf63c5"
    sha256 cellar: :any,                 x86_64_linux:  "0fe2ce6d49058735ffef930affb5ab815798bdff94fdffb4c022a557360ef2a9"
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