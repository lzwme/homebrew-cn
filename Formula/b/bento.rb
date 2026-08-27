class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://ghfast.top/https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "e5ebf27d2571e931d607964545987a94d8decbe033e65d6896b6b4d8d87bd9ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6d824813b65138df40517192216a49153bdbc02eed996669c7744a37ee7033d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60c43b5624cb187379340335f591d0f8c6458ce386268da37dcfa67baf3cd414"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb24f053509a1373c78bfb394dbb172915a8b88b320b1d17011a86867aa19912"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c950eadcc25a5fa81d495097ae427934646b3b03bed151ec2b51ce489a2c091"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "318220ca7940475baeeb83c398603d8a3f139ea72403a06511a9a5048fae0511"
    sha256 cellar: :any,                 x86_64_linux:  "af59498c390dbe786f4ed547d0c10dbee53da4d55d44974227e5fa6f9233be55"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/warpstreamlabs/bento/internal/cli.Version=#{version} -X main.Version=#{version}"
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