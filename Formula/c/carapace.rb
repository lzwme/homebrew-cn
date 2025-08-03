class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://ghfast.top/https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "7460eef0ea7d19e5d0082e425fbef08f506d926d995701c7a8c3c6e90c9e61c5"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a67e00e824df654068fbb83d8700bd1dca16fd646bd7542a4852e46938d74e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a67e00e824df654068fbb83d8700bd1dca16fd646bd7542a4852e46938d74e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a67e00e824df654068fbb83d8700bd1dca16fd646bd7542a4852e46938d74e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d92b9cb0bf6efa6c3ef5cdb3c67caa2be9295eb369b0e65262f282799cb48a47"
    sha256 cellar: :any_skip_relocation, ventura:       "d92b9cb0bf6efa6c3ef5cdb3c67caa2be9295eb369b0e65262f282799cb48a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f6b67ee070ce4f1331fe98f01842667a8ef75930389c6a59b03fac45583adc0"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end