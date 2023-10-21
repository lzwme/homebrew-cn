class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://ghproxy.com/https://github.com/tektoncd/cli/archive/v0.32.2.tar.gz"
  sha256 "374f965cd5006c54dfed1f69d1bba16604126361735826647877ac387feeb201"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24ae3a2358153c65c59b231dc12f81d9af95524820186fb12fa8d181ff13ecae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "323f4a5eacfb620cb6189dfef51f5ecc30a73c1a84416020a88b00c93ee1fe24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cd052cf8b6cff6fa96d500abc57594b06ba28cb17efd5281f00eac32ebbd18f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7eedcdc6f8b3b3e592d76d7d1d157cdeb475b2abcc9f25055f85f43dee376ce1"
    sha256 cellar: :any_skip_relocation, ventura:        "f3d27cb10272c23c8c86cec892fe309c53d76b38e0aa24d3e84901e0273a33a2"
    sha256 cellar: :any_skip_relocation, monterey:       "222f13c36591715f9866d829a0964dbe45e863d8baf368907f67bff83705d93b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f821a7b28b959a8a3b00f088878df44da1f89ebe2e6a4b368600ebbc6cee4a8f"
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