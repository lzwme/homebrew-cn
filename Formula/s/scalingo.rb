class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://ghfast.top/https://github.com/Scalingo/cli/archive/refs/tags/1.37.0.tar.gz"
  sha256 "39dd0f2e89c69ae73cb58d0207b73b123cc0cb0f670ea0007f1f101f4caa22e7"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "344f323b7cbdf7458561f256610f0a5c9572178d7c23751c55e5e7791be226a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "344f323b7cbdf7458561f256610f0a5c9572178d7c23751c55e5e7791be226a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "344f323b7cbdf7458561f256610f0a5c9572178d7c23751c55e5e7791be226a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "798edf6617b7bc76a3a107a4b2990a778c2297dce660adcc756544c52ff43409"
    sha256 cellar: :any_skip_relocation, ventura:       "798edf6617b7bc76a3a107a4b2990a778c2297dce660adcc756544c52ff43409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13dde2c49a4dc894593aa82f41d66588e877de66f553c6b46beaad2a31785f2b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"

    bash_completion.install "cmd/autocomplete/scripts/scalingo_complete.bash" => "scalingo"
    zsh_completion.install "cmd/autocomplete/scripts/scalingo_complete.zsh" => "_scalingo"
  end

  test do
    expected = <<~END
      ┌───────────────────┬───────┐
      │ CONFIGURATION KEY │ VALUE │
      ├───────────────────┼───────┤
      │ region            │       │
      └───────────────────┴───────┘
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end