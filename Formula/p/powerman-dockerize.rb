class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize.git",
      tag:      "v0.23.2",
      revision: "b2733c291f1c3be71e0559d35efde3a887dc7060"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cacb9c8c99dea828b7cbe8d566b4f34b075602eb4c6efa22a3c0e572f12abe99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cacb9c8c99dea828b7cbe8d566b4f34b075602eb4c6efa22a3c0e572f12abe99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cacb9c8c99dea828b7cbe8d566b4f34b075602eb4c6efa22a3c0e572f12abe99"
    sha256 cellar: :any_skip_relocation, sonoma:        "0562e04edc456f122f46a454234f49acb227d846f4595cc9e61f408f50c66026"
    sha256 cellar: :any_skip_relocation, ventura:       "0562e04edc456f122f46a454234f49acb227d846f4595cc9e61f408f50c66026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f6f8becec6b760a1ce4cc250770c9207821b42f4bd8917ea44db186fb4e6c3b"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end