class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://ghproxy.com/https://github.com/tektoncd/cli/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "18888780d58e1cd88fc943a6b15c9940599383466d33e11fa96f61f83bd755bc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2c669dd7e7f8c4d45ff3e66353103c9ec70aea04d837040dca93d244d37c1d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc1df83f326b54d874937b7574e176093c311083aeacd9925936c9948be7d6f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec250e6445a15e23ee5a35395e726bd0ebac23847dcceaafce24d9ead9278ae8"
    sha256 cellar: :any_skip_relocation, sonoma:         "520c6d870aa6cb9682cd48533f4bdb855fa921474681b4433b27b3573b97930d"
    sha256 cellar: :any_skip_relocation, ventura:        "1ef65a70e61c892eb73c1b4dc0dfd6a10619d186d32edebe8ff79f331efbd929"
    sha256 cellar: :any_skip_relocation, monterey:       "696b5af54f6d2b29b777ddf6e76826fb86dbe1a1490f6983db71ca6695d14fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01e4761dcd3032837806d508a8492c594bc1fefe8c943a9006ba633683854aec"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", "completion", base_name: "tkn")
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end