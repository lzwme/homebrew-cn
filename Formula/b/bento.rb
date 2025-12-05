class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://ghfast.top/https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "792cf0c3492c3902f9abb713c213508c4951c2018304524b5227a805d92eba09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fe57f1bd1d617e4554b0b61166fe1b70c2a8f70db1d60a41890054ccb3d9d57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45d0b0a1e07f8388b9a460ab784e70cb8dbcd29c8590afce31e0609a3aad63a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54f31a4b4c618fa5ee6c89617d1b02964c9abd3bf272268c88a807e1e22acaf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0fdfa043c21bcb91396271edce9f1642f9771f7aac438688876f8e0af13cca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c3cac97e441147a6bd575bec2ce395863bc33519265da2d689af13460d3b021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de046df1bd38b8168579c0ef77e39c3324ba86d5aa3ee63117657467bfefebdc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w  -X github.com/warpstreamlabs/bento/internal/cli.Version=#{version} -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bento"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bento --version")

    (testpath/"config.yaml").write <<~YAML
      input:
        stdin: {}#{" "}

      pipeline:
        processors:
          - mapping: root = content().uppercase()

      output:
        stdout: {}
    YAML

    output = shell_output("echo foobar | bento -c #{testpath}/config.yaml")
    assert_match "FOOBAR", output
  end
end