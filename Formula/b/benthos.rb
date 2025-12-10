class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://ghfast.top/https://github.com/redpanda-data/benthos/archive/refs/tags/v4.62.0.tar.gz"
  sha256 "93d52a8b0e4dd0f141f51e7adaa30db0193012387f016be85605235d5a66ae86"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae7383ea18b5a99df47d2c62ae91b8d2653ad890db935d4c2d30508dba6f2aa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae7383ea18b5a99df47d2c62ae91b8d2653ad890db935d4c2d30508dba6f2aa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae7383ea18b5a99df47d2c62ae91b8d2653ad890db935d4c2d30508dba6f2aa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b89281141d3ee4c7f34f9ccbf014b40d4c494914eb2f0b53c22b1b05cdef5206"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e7e5e63840f9eadd26f0d44a369b301b0d0aa2f7397abf4a401315cb85a5be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c22c23852a6bfad4fe5249b72f94b92cd857294a4ed9a7f87957fe71a3f9101"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~YAML
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    YAML
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end