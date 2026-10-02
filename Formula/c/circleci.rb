class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.51853",
      revision: "c50ca60c92738e3452c379606a840e0131521bb5"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e543dba55250faef5820f4f3b1da3cd290b953335773cbbebe9c73690dffdc2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3f850cf9cdd6a1ec4ee6eed0ed82278b58e2b0975bc59300733f538f9de4eb71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "abfc9551dae92841cb00da4e4dd8c44cdfeffdd16474f5f1fe0a43f36401a3f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "91bb5f96c2f7dfc97595e2a307bf29a3cfa19267cc83817c82ad228192661665"
    sha256 cellar: :any,                 x86_64_linux:      "0c29f068ff8184bdf88e088ecb1384a7d347bdb558b3d3056cae1882cf7c6c16"
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