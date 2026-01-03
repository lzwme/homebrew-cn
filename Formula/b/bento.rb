class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://ghfast.top/https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "27ace06096e54adcb7977a79a408673dbbdf52fc31029cc84b61d144c543e1dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8c96f0f5d92e5fce34bb0e097be41e32cc92c628a0e3af3323f431b30ec2769"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54ddc8d5b6a56a576818b38e2fa58c237fe47a76e73f96484ab0fe4a4dde78a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5744b7843deb419f77d45abda41c0e1b676b2e86ae79d2151336009ec0dc3869"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1ce758187d05873b31a7b6e1ba6cc71618b54aeb33a278f7802998d77e7f517"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e75921439218a452ad48525f7bbdf152ffc9fd9c12365c989b2266835488de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e77e4e8103417b705a7531b21cfed3b3b4379e248d7f26a7ea782f18502a6906"
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