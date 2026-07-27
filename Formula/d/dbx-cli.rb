class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.43.tar.gz"
  sha256 "b4478cd9d9970614ae1401ed927d1ac8a9730ee3037eef4c6aee23c0b7cd3049"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75f45565475aee0228e08df35033ba3a0353836c7403a60d1e51d488458fbce7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e167cf7d7fac5b31a026109cf9dc87e5793e8287684406a2164fb107b4d77eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81c9b6baef0fdab0630a909359efc15f8eb2246aadc9496ff46262a5572880bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dd8889573a4709a16cd049ec6315e2fef0e1c11218cec45a172eb47e89485bd"
    sha256 cellar: :any,                 arm64_linux:   "ee9fa2fa6e0475f51a0124044c01873a4bbb4aac9837ececdba5669ca684ac0a"
    sha256 cellar: :any,                 x86_64_linux:  "62ca6ec3da7409d833c0b91d52d1e7e1981900d4b9aeb7bfe785e62cf5c7463a"
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