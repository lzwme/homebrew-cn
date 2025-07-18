class ApiLinter < Formula
  desc "Linter for APIs defined in protocol buffers"
  homepage "https://linter.aip.dev/"
  url "https://ghfast.top/https://github.com/googleapis/api-linter/archive/refs/tags/v1.70.0.tar.gz"
  sha256 "46aff27153be59a2c9f672f90d6521a2985782b13af120a1e28db31a53e90fd6"
  license "Apache-2.0"
  head "https://github.com/googleapis/api-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efde53f213c29c6964a720bbbc864e3ef0751276b81327f69ab60a3029b2a3e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efde53f213c29c6964a720bbbc864e3ef0751276b81327f69ab60a3029b2a3e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efde53f213c29c6964a720bbbc864e3ef0751276b81327f69ab60a3029b2a3e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "34658d7283bfb9e4a55e5b1121c6769ee23fec2c95c69426a71670cbde8b43e2"
    sha256 cellar: :any_skip_relocation, ventura:       "34658d7283bfb9e4a55e5b1121c6769ee23fec2c95c69426a71670cbde8b43e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fadf97fed74685cf1121d21d08ee89f281977c6ef38f83899411d92eecd320d2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/api-linter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/api-linter --version")

    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;

      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS

    assert_match "message: Missing comment over \"Request\"", shell_output("#{bin}/api-linter proto3.proto 2>&1")
  end
end