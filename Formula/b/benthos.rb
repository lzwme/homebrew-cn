class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://ghproxy.com/https://github.com/benthosdev/benthos/archive/refs/tags/v4.24.0.tar.gz"
  sha256 "c615844e5178d9e666291b00fd2ddea53055dee2c4eacba99b7d06ed565a309d"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acd1ed4a9752d719d3884a613536bb7a476bd4fb5b054160a99b91bae7792f1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57e64c8e6ad0d62144ff4bbcd259e666588e10b9820ac50df45d9bac387cd2ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcfad4fa37ff18ce50d449c2cd6ced30eef025a5e6a7524340823565c4a0542a"
    sha256 cellar: :any_skip_relocation, sonoma:         "49a9a7dfccbef33b3c0f98254b322d590c4d9db623fe496d71c876fe92932aca"
    sha256 cellar: :any_skip_relocation, ventura:        "c24e52e6d747440469bc5dd8c2d36af0a621bb7bfca0f895e9240e3972ab7224"
    sha256 cellar: :any_skip_relocation, monterey:       "6ab2afce065fe0dcced1f1224b68e6034da46375ce8e29bd17de7b2cdf0093b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4862dd16c05972738234a223b7e71dc02c8a3be26d6e2dfcfe46dcb05424871"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "target/bin/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~EOS
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
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end