require "languagenode"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https:aws.github.iocopilot-cli"
  url "https:github.comawscopilot-cli.git",
      tag:      "v1.33.0",
      revision: "cc057a9529d84e59858199822b588f51b494b358"
  license "Apache-2.0"
  head "https:github.comawscopilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "419b581a1b6264570a5c61df9f00c99fd3f7d8359a279906978dc02d6ceb2874"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "030968c407a10524b439c743508314c5a33f841a781ac51ad5d276e6a0702c63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f3547cc4fc79149b0b732c4f48534043d1e568e048e497de67c4ba8e73aa60e"
    sha256 cellar: :any_skip_relocation, sonoma:         "11806a391383abd0935d24c1e726e2ac435013c8b762528fd907acbeef10f5a6"
    sha256 cellar: :any_skip_relocation, ventura:        "ddb115fbf0b7b53927051797290e42cc32c415e59d003f0a28b9161de61fc32c"
    sha256 cellar: :any_skip_relocation, monterey:       "66514bdaf2e00f38facd22ad2cb23619f5e4737160d541261e41a21e3f90970c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50e1494fa4a9740d7c0265d87d93266fd827683966a5fb5e49dd53ec51cdc973"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    Language::Node.setup_npm_environment

    system "make", "tools"
    system "make", "package-custom-resources"
    system "make", "build"

    bin.install "binlocalcopilot"

    generate_completions_from_executable(bin"copilot", "completion")
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    begin
      _, stdout, wait_thr = Open3.popen2("AWS_REGION=eu-west-1 #{bin}copilot init 2>&1")
      assert_match "Note: It's best to run this command in the root of your Git repository", stdout.gets("\n")
    ensure
      Process.kill 9, wait_thr.pid
    end

    assert_match "Run `copilot app init` to create an application",
      shell_output("AWS_REGION=eu-west-1 #{bin}copilot pipeline init 2>&1", 1)
  end
end