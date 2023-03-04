class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://ghproxy.com/https://github.com/Scalingo/cli/archive/1.28.0.tar.gz"
  sha256 "26c58e02b09b90b7b1823cfad1df4137d14f622265b063d2d0d1aae7a3d29a50"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1c2fca6c2f9ad7cad8a2c5b3d7f88076cd0eb735dc3a5094d76cccae592c581"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed0ce14e598932e784b0d961244b1f7c4660328093eca5d9a3fa78bd5de45d1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6060c0ce21d3e66304e6a0a599e47207afc7323643ba63bd8c4846a5220a57d9"
    sha256 cellar: :any_skip_relocation, ventura:        "d4e389159779099331f43f7af18c49526bcfd910af6e3feb73e19b8e0266d382"
    sha256 cellar: :any_skip_relocation, monterey:       "5e595096402b4f8db27c759ff44a59fc9e799b3412373470c77fe252d7c9934e"
    sha256 cellar: :any_skip_relocation, big_sur:        "17ca4f512c35b603e5ade5e600d058194e3d6de4c6d21a7f4d7d48b3f24c327c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab78afd3a4a4169ed812d255cc5dd9f730536896023ef537e140229a02c3e6c6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"
  end

  test do
    expected = <<~END
      +-------------------+-------+
      | CONFIGURATION KEY | VALUE |
      +-------------------+-------+
      | region            |       |
      +-------------------+-------+
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end