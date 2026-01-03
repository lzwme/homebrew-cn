class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "2684905740870592b209c6aed89ab7b1dd40ed3cea67ca957fa7f06992f51495"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "645a1cf4f1a3ef6c210bd40147c75cd149fe1e713b6f9932ca6c09be1ff54fca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a19a24554c6c29a28a8c5d0fc6076ffdaa36708b098bfc56a5e6b412ca08185e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6020c109da4bcad9097263a361f1945ab5da42a0b6ffc0aea0e418adf20e708f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c4bd2d9a44ab19b8048a89b92e2f82187efff6fdf0ca3ddcf7870e5bb6fe43b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1c0cea9af0e7650713ad44dc605b39dbeb23fe9520ea2f84045ae86858f9be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f032b1fb03e0bd5bdce5d258e6cc015a98bc341dae7b92cf235d5ecadac72ee"
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