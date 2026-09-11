class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.50006",
      revision: "673790bcdb057f5eb92fd121a864d3f0a9d13116"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7eb6b2809e89bea3c9b958fe8e5df6970d28ead46c75e3ad00af4393923b6a9a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ffcca1b1592984ffcd66f80a8ba0c0012d10affa5130b5077a14ffb1990e9f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eb358ac29792e2c20ccfb7740a7db6c28a4e9aaa021eb9a697a1856b1384de71"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "efec806853ea0ed461de8173e3bf1f24fb6b8532ea72da13536df57daa9a29f5"
    sha256 cellar: :any,                 x86_64_linux:      "58d769bb842b8a8bb0266e8131558dddd4b96ea16d1f8d46f6c763fb1f85601d"
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