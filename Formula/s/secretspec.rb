class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "85a7510aa0d8ec2621bc91cff8d949fd9285adb6a715cf8740bc11a69b53402d"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60e8dfac70bd24039c069397bcf129cc0b6844f2b4f05e8a7e700bab89c0d7e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "303857d7909c831c913867122af37305edf40ffd0d43f73999eb3a932a2d4b4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e485d4069c5a8838d27988f7f50f62b7ff83048d5bb049ef0ada7c40c630726f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2305f928444312b952b4b2e286de792ff2104f5a8a0355e6d75928c57b70d6cd"
    sha256 cellar: :any,                 arm64_linux:   "66e55d69a8e09c9b7459163b7c7d6c04af0e3b9749b5942afdd684e16637f78e"
    sha256 cellar: :any,                 x86_64_linux:  "2480a6ddf6e8873bd1ea007436bf28a75d8ca66fb89fa62eddde3230af3e4e45"
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