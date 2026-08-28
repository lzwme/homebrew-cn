class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.128.tar.gz"
  sha256 "662fd8dd5d836547e45aa91876f4daa867397af7a9d83eaa0cccd9fcb6876a6d"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8333f742f4cad208a85daf83857fe278e04c5f42d28c110bdf043c3d7cabf9cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8333f742f4cad208a85daf83857fe278e04c5f42d28c110bdf043c3d7cabf9cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8333f742f4cad208a85daf83857fe278e04c5f42d28c110bdf043c3d7cabf9cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ca63b6e2a955062758d64b7f551d41152fb2c39d3a41f2f2a0ff935914733e7"
    sha256 cellar: :any,                 x86_64_linux:  "50c7f5c7e1424f174eeb2680c85e8a48d8c32c1a2300166e09c34e42675ac6c6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end