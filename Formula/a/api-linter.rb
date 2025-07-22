class ApiLinter < Formula
  desc "Linter for APIs defined in protocol buffers"
  homepage "https://linter.aip.dev/"
  url "https://ghfast.top/https://github.com/googleapis/api-linter/archive/refs/tags/v1.70.1.tar.gz"
  sha256 "38f4e72c9018ed44e3ccb879f55b50183217e7a23cffad8b9bbc1c23cfb9c2b5"
  license "Apache-2.0"
  head "https://github.com/googleapis/api-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03617cadfc1aa65d34fc27c0aee1a675021ff96a4d92cb3b20361ec51ec32fef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03617cadfc1aa65d34fc27c0aee1a675021ff96a4d92cb3b20361ec51ec32fef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03617cadfc1aa65d34fc27c0aee1a675021ff96a4d92cb3b20361ec51ec32fef"
    sha256 cellar: :any_skip_relocation, sonoma:        "8edc171f3ae2ffb4b428d887f3e54af2db6d34f05509ede84885c79b4439487c"
    sha256 cellar: :any_skip_relocation, ventura:       "8edc171f3ae2ffb4b428d887f3e54af2db6d34f05509ede84885c79b4439487c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43e78030ac1e4d2abf94d219d20711a3d396971f55aa106ce989fb43a801578c"
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