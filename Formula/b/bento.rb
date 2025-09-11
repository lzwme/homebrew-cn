class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://ghfast.top/https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "ca87ade78c5c65a902d980ccded5102189a69d0051213168f65a6eac15951ec6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44eb654f9dcf96d3ca45db0c2258dd1c051ce39390442b43b9594ece04533c5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d4d81f86c30dc6320fbc50c6bbaff0b7352d9cc31e15866e660f452a8d18164"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9a94be95bda0a163659dcb0ceecc523a6bb71820230635b3a1fe7a395027d6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f51626ae45f850218c96ae5f49f25a7ca4f77864d691c5520a4c8317b3f7bad9"
    sha256 cellar: :any_skip_relocation, ventura:       "b2eeeada013c6ff44cc981d23520854a4b332834ec80a5a29c5ca51d787bbfac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f6d5fed0198099900a04a9876d2f2766e88ba7ab82da7dec5d6a982927f9da0"
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