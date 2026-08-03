class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.52.tar.gz"
  sha256 "59f4726a12e82c853c3ce4c0724ec426dc0a9699579879ce8a34798fa89382e0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db3e1457dabd038a2d364df8c5e4c41dff1f4427a53e0a72d25a1b07b45a2c02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dac120f73defe4562e91a6b990de9b5ccf5f0f75e935d952bd67e95f9448e4e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ac1d26d49c0d86997f9410c9f10316a67b61d5fead508e711c6eeb216a6149c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d64f4a197834f1a79cf7df8478b591450561881731cd75381d9b1d0e82bffba3"
    sha256 cellar: :any,                 arm64_linux:   "acd5ed927d1beeb40be110533dc7f66ab3fcfe9cbd20a84b8b35f867c0585700"
    sha256 cellar: :any,                 x86_64_linux:  "a109a0cb32af9f1d2a8dd77f10d42360c4fed98523365d7ea0477dcdc6b4acd2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dbx-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbx --version")

    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end