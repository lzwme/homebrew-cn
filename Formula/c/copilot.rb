require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.30.0",
      revision: "7dcd301d9ddbd6563079bf2a5a3f8d2b38c8ebea"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65d06a1187ccf8ec2fc5d2aefffaaab084a937ca8d3052d7a259d6e1127cc16d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a46ab3fe978546e14596c6ca4c81239f823eaddbd82ee5c0b9c8684fd7c3f9c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4613833d9ee5e47b3de2b0b3475f119473e092cce7d6226f1c8e3a287c10b912"
    sha256 cellar: :any_skip_relocation, ventura:        "eff8cbe90e0c24af9ca96319f29990be9bd2396bb41adfacd0bd0d9daa422f58"
    sha256 cellar: :any_skip_relocation, monterey:       "9c476aa0c62eecb7cd9ff15f9e4f2e86aa82395b1be81a70527c11894dcee0db"
    sha256 cellar: :any_skip_relocation, big_sur:        "96183d93ee8a04132508693faae6bcab75bd7743fca0ac709c3e73f96aff0433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b0dffbe87c36c8f908f0f20e2d7413249f7757b514d95242f3b6e2ce7be646b"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    Language::Node.setup_npm_environment

    system "make", "tools"
    system "make", "package-custom-resources"
    system "make", "build"

    bin.install "bin/local/copilot"

    generate_completions_from_executable(bin/"copilot", "completion")
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    begin
      _, stdout, wait_thr = Open3.popen2("AWS_REGION=eu-west-1 #{bin}/copilot init 2>&1")
      assert_match "Note: It's best to run this command in the root of your Git repository", stdout.gets("\n")
    ensure
      Process.kill 9, wait_thr.pid
    end

    assert_match "Run `copilot app init` to create an application",
      shell_output("AWS_REGION=eu-west-1 #{bin}/copilot pipeline init 2>&1", 1)
  end
end