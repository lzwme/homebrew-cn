class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.50849",
      revision: "42fd89089e30bead5172424752238006cf764dd8"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b01801a8450a0c1411ec7ccf9414d1cbb35303818c1fa5980035485531e99e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6903278ad145b900785b3b5e33c9f9ede7f841b402224ba2d7ea33effcf1d5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd6acca7c38147e9289ddc45014e48dae6239dc5cf524332252ea7a3cacb1aab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "83736d4bdcfa53da077adb8830f248f2c674bdf00b2a766a92441fc407d3568c"
    sha256 cellar: :any,                 x86_64_linux:      "bd1773fac5605db1a5914e42dd4d41d01e2bf851021bc51f5045985f73b18fb7"
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