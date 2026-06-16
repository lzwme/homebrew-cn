class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.100.9.tar.gz"
  sha256 "8e0425473b055342b00fb973e46bf1177b82d0b4fa41f4e3dfc970efbe3bc47d"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08b6c644d0feef068b4b20e99454f83aba15b3fe7f5e1df21fe8a751d179b724"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08b6c644d0feef068b4b20e99454f83aba15b3fe7f5e1df21fe8a751d179b724"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08b6c644d0feef068b4b20e99454f83aba15b3fe7f5e1df21fe8a751d179b724"
    sha256 cellar: :any_skip_relocation, sonoma:        "f00e79f352f3bf1eac07843bf0f82b87e26cae116cbee79ab2101fa7b1875def"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22d19672d400d11f4d772c659a476cfb1d72afbb34f9af97ef2d195a86b18019"
    sha256 cellar: :any,                 x86_64_linux:  "693bdb649d2a7256b9ec27d331866a08b49c04a2938e5cef5fcc1654e4cf2784"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end