class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.51932",
      revision: "be3dd8e85cfce2722dd1e94c3498aa1a2719f9a0"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9c5f8b84ae5ac881a10d058774406efa1e1e82a9de2b26cfb337ec5147e9c87"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "243655eca3e3e67e0afd57ab441be540bdcb7fc826f46fed840934a7c700bc61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "002be976937610757c243b8cdaf10ca4197557045675840b11682a767e4354fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7dbc988d1db37fff3ce0e2babb13055be39d2953d3381b994e652fba0451787b"
    sha256 cellar: :any,                 x86_64_linux:      "a5e6e02c1e3b9edf7a021654fbe133ae8e5ae5f167d44946e0c20ac3204107c4"
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