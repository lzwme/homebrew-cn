class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghproxy.com/https://github.com/onflow/flow-cli/archive/v1.3.2.tar.gz"
  sha256 "7bb1a9604a6cfe2a963fbf661307f97850351bc17a70715c02e01fc2e0b1f6aa"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1be501d235a2e4ef3e6b808ebbe4d26088e2900fa5060702e02fe9f18ab621f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "775b2ee800c9481f18a2a3d537afb7ae14a4cb5bf013850fe133d3e998ab3c3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fac0fce6a7849d7668638eeb01ed21b9b80d69767a3aaab718e796ea9ba4aac2"
    sha256 cellar: :any_skip_relocation, ventura:        "e278fbbc29b91c55612a04cfc652010c76a06d9a1b769b3b94c41616763b9065"
    sha256 cellar: :any_skip_relocation, monterey:       "40b011535bb19f42872b8f74c49bbc939b59d9aaa5afca5cb7ca28f3e2a66bcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e7bbe0f7f31489b84a92883cd4b632ce8c859dc9709780679c033e53377e73c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5651f7184d6987648d3321dd60be7e3820616832279bb76446fea3dc462ccf0"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end