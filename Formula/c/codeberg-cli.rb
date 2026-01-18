class CodebergCli < Formula
  desc "CLI for Codeberg"
  homepage "https://codeberg.org/Aviac/codeberg-cli"
  url "https://codeberg.org/Aviac/codeberg-cli/archive/v0.5.3.tar.gz"
  sha256 "2c61338400569660d069304a213d2f3bfc9ef8e9f541f561eb4da23a98304499"
  license "AGPL-3.0-or-later"
  head "https://codeberg.org/Aviac/codeberg-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "605359c2e068f2e67c4f81a9896a19c6740167fe1b1476c60f241657c8841fab"
    sha256 cellar: :any,                 arm64_sequoia: "3fe8673b2a6c7f0b8c237adde6685e837c1da6dfc9fba0971d8752df2fd669ef"
    sha256 cellar: :any,                 arm64_sonoma:  "1071a90d7eae3d1840d7669934bc7a9b305aee74974ccb0dfd966b92dfb9be7b"
    sha256 cellar: :any,                 sonoma:        "c491e1fdc0fc706b442d54da2a0b314025e25d2e02ee321c360042bec70be28f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48b07566e6a25a92ec6c3f8d46725c028c362dd6bf21f1fca398ff2b6b771e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ef806c8947b0a0d6f153d1cf319fcfcdcf3d4357db9d533ffe0cffab5ea7655"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"berg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berg --version")

    assert_match "Successfully created berg config", shell_output("#{bin}/berg config generate")

    output = shell_output("#{bin}/berg repo info --owner-repo Aviac/codeberg-cli 2>&1", 1)
    assert_match "Couldn't find login data", output
  end
end