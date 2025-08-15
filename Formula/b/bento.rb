class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://ghfast.top/https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "20fa0ccb49310884f259bc476ae26b81eb8407d22395d839229b6bafe720a5ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0b1f396170dc069fdd4117d0e20dcf3a9e78126c81512e98bab621421fe1110"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cad7da77b1bab010f099d2391a24fdf0d91440fb34c8ba1cb6f1c10bae37f705"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8eb859ec47c7e5ed94d94a5fe639e362fb06f4d62ddfb3dcbc1e2bb1ff0498fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1efaba4a6cee402843b5e266a17f984159fe0cc15aa1f215c160666ffa3bd48f"
    sha256 cellar: :any_skip_relocation, ventura:       "86a66e84933f4d4f77eb0e7130090c07a431f5528dcfbfc80e2b8c9ddd9b2227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3eced3ecaa56a848c6e65a52cfc2c1fda2c6a447ecdd2d616e06ed4c8a5f1b9"
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