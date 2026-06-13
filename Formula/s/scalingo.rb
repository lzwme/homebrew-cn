class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://ghfast.top/https://github.com/Scalingo/cli/archive/refs/tags/1.45.0.tar.gz"
  sha256 "0552aa61af9abf236c4102ade445e44c0d4aa2e8aa51b23158657d0ce390cf67"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac7583631558e5d15cda0a0fd96474b3e47cc0582f1716d53b09ec1a2238bea3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac7583631558e5d15cda0a0fd96474b3e47cc0582f1716d53b09ec1a2238bea3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac7583631558e5d15cda0a0fd96474b3e47cc0582f1716d53b09ec1a2238bea3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7866bc863386e51d499436a29ce1a577fb0f00e41b1177c780307e3ff2c45c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "710438b44853f91af8b6063d1ae2f1eb82a7127727e9a0af9f6a0665177f91a3"
    sha256 cellar: :any,                 x86_64_linux:  "c93b067ca458e282b5a3dc0bd764b62b34dd1e6303d2c5e723344aeb268871a7"
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