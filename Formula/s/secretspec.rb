class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "eca629033bd3e86f6c746f11e2cc0d7a0cb73ec7806bd49e6cfec0f8cd131c16"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c8d33dcdff6e0acf155d64479e5d7db425819903be9bf1c7a043a1e02dc9474"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67f547c90a3eed49ac503ad24de387124f15c508aea7e9a1ff244a6da1a4dcf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2991fb6304eb146782096994ffc33264b9c6a7206522a28d78071209475e75f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "769f7ebd6c0b120b36f9125f97bf6180d2a57cfc335930be68135e8bfa957db2"
    sha256 cellar: :any,                 arm64_linux:   "f27719304cc58e653d267962a7b4a84085ccaf47a1ad44ef9f490ccc3d5e58c6"
    sha256 cellar: :any,                 x86_64_linux:  "3f98928348f7134014bc424d77eb05cc94a18530fa02c8d9c01eb1adf6000a38"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
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