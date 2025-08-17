class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://ghfast.top/https://github.com/koki-develop/gat/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "90f404043dabfe445bf354efbd83029f519dc7d4ce84839639bbd8c261290803"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b39736f99cb2928ce9a76cd0f16f9080512f3375c8073e75d6332f6d98d938d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b39736f99cb2928ce9a76cd0f16f9080512f3375c8073e75d6332f6d98d938d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b39736f99cb2928ce9a76cd0f16f9080512f3375c8073e75d6332f6d98d938d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "34c80fd9ebfaf31de28eed56001982f6aa6cbf85b7ccf7f7d16b5e5aadfdd493"
    sha256 cellar: :any_skip_relocation, ventura:       "34c80fd9ebfaf31de28eed56001982f6aa6cbf85b7ccf7f7d16b5e5aadfdd493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c8af3962684a120ba67701fbaf83a64e0cb83288df64cb95533d2c0a9b9565e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end