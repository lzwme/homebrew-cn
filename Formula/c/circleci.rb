class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.52041",
      revision: "e0dfe1e6deed7217bb14e278bb57526c1305a4f3"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d023d42a6bab216f1eeaddc6b5085821c01fcd734fe6a66f11e1be1e34a0b760"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8dc1fcf6bba2438dbdec95d9b97293aaf52a5980519ba6ac7318f13a43996649"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10a96fcdcea44becf5853422f9a276f0df233de68f5c680fca422e7f6b75d0ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8a2674773e3c0c4bea65819513f26a675ca5226b7791ffc36b227ce54c496e67"
    sha256 cellar: :any,                 x86_64_linux:      "6f560c60580e8bb954c8b3687748f18f8a9bdb7edbfa36284cccb7faf6f3b91b"
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