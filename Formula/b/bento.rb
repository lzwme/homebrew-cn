class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://ghfast.top/https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "55447f8726afa5ee7574ee641a0f42d6eb0c9d6e92a340d0641a085bb79ad15f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6cb36363502faa446f49dc5f0d18109b83fb473b4afd699504909c97bbf8ffc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ade885c4083905f2b2ad78019e41fbef2cf5de9656a8e0f97208df761ee019ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac4c517a04bbcfe01102a10f5867d1b558b33b9968aaf5982b3ba996f4d33340"
    sha256 cellar: :any_skip_relocation, sonoma:        "f34259911f3b1040c5ec0afe1641bf991228760d64d5f4c448644284db2c8037"
    sha256 cellar: :any_skip_relocation, ventura:       "70398a7c952bcff3fef77977d91a62e9485346916300263de9faa192eb3b9742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a74bf11f16cb5fbb0e5676acced41b72890ecb6f2a2bee38e2cd9e005867f7cf"
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