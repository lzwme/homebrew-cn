require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.29.0",
      revision: "55dba4d34ba58be60af2adf7350c51de538b08e8"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12bad61e003ea7b5296eadf5097b9f75e19abbaff73eba7fefd33a981796d3d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2db2d30267efb30cda4bac53753c602eff18ce314b1265a030042b39e5deebc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c28d142367d355a5573eb9553e5ddaa7eb17fce19ab597a5abc09c9119aad1e"
    sha256 cellar: :any_skip_relocation, ventura:        "850a8371c8defc8311d9a3367f749749e97b49b3643e12dc2bdf6d7d272dc010"
    sha256 cellar: :any_skip_relocation, monterey:       "0a23b2d2047a4ae907317a054e1f2ba576a42a5a9d52b76ba1b6bd49641cfb00"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c1ef0d490d1c6df910c7b1d63790a562fca118f2b7533401a6bc2ee8329bd9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c83c48ad7ae8df109b4708f429fb5f9d632264dc7894dc51689a4c659582dbcc"
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