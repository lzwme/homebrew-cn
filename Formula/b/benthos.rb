class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://ghfast.top/https://github.com/redpanda-data/benthos/archive/refs/tags/v4.74.0.tar.gz"
  sha256 "f88a6b296eff97e285d55749942ae24dd2e497434d764892961df9aefc07852e"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "499326e6372ab81d2f02f2aada82bac6a3749a3dfd731434659a94c351d0863d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "499326e6372ab81d2f02f2aada82bac6a3749a3dfd731434659a94c351d0863d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "499326e6372ab81d2f02f2aada82bac6a3749a3dfd731434659a94c351d0863d"
    sha256 cellar: :any_skip_relocation, sonoma:        "387b67851fb47899b8b45b0ed9dc14cba3d48e294887fbe676e80db720ce8775"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c213bb4f3b9d51f65cec68e65f3f32186aa22e7d82259d08ed4111b948b3b60"
    sha256 cellar: :any,                 x86_64_linux:  "3d6f6bdc4cbf2043b3acef2f2b72beb0e0fd2e317cada91f317d7af0f34fe819"
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