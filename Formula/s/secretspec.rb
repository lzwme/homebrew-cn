class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "e2bc9cd215f7ddf74d7ef00bbe7cda318354a8223e7c04d7564759c70f3730b0"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "93ca1e9d4a39b121c321f665b38c21de1385fa44152878bc51df4a49356cb9cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3a1e6501ca3ac2bb7c3ff32ff545815c41e3f115017c669f38c4efad5480e9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00ec1c821060956cdae207c3e2d776162e5c07cbee5bcd341933f6ed69207320"
    sha256 cellar: :any,                 arm64_linux:       "de9047f0ca50138d786885d0bbadc85162ee85a3c8758900c5804ee227cff15b"
    sha256 cellar: :any,                 x86_64_linux:      "041395cf177a029bf6586aec365f5cf7b69d5fedf83d9a62c5d678f7f4a90931"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end