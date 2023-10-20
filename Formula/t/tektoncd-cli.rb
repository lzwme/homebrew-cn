class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://ghproxy.com/https://github.com/tektoncd/cli/archive/v0.32.1.tar.gz"
  sha256 "bd74b4c396d7ea2a880724d7175c2a3a7be6ae4a10f87a60bdbbc657ef73fae8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30420c6cfc23b95f0792c691ddd13bf26568f5f3059e41952c6ae36a406567ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "854da3802414d94f34835791df2c5ac76f46693c8372295dcc628de7d1fa2d75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "570c5231c6e57d98a07759b0d5eb165f023ab827f1abb83ac4d1d2ea07351e1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e245763c60e12520118bfeab376874758822189aa13a9ea9ca7d2abcfb122ff8"
    sha256 cellar: :any_skip_relocation, ventura:        "6c2b8b194eef6fdba2ea94860556a946ac46d42e53dcd0b2e831bbd016820ae5"
    sha256 cellar: :any_skip_relocation, monterey:       "d3b3c0c9c81c54d8804f8b2f4d9e6e2b48acd9deec9ab96abb573326ceee9f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0c3ed7c4fc79fcf8ddac18c800e89cf3e0e9e6eeb71ce1640ab7c68bb1378a7"
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