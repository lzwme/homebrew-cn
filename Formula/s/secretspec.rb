class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "dd34eccc0c2adc3614d44d8cc9d48ca0a3a2004d8878f3d0af0e7d5cc80188ba"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a3114418afd3ba27522fe2f05cbf9f87637d1e0ae8f7a98d578d52ea2731e8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "750e8deb36d50f183f127b0b28bc78b9e599ac4e26130e801471044326d63e14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edd7ba96da9ceca8fde1ee89dfc0069d7a7b2e65bf32f8d7d13a13eb0cd77741"
    sha256 cellar: :any_skip_relocation, sonoma:        "068ef5a11ef3e88145976a11622d075a53fb5856d4939ffbe1a26fe35246270b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58d4567d970d50d6f3d8dc9831202cfa19d8266bda7f3ef47c46ad3bf5e93ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d2c6cd62092a09e7a14bf3f5537da18ca2db5fca13665fa003d5d26ce07da1b"
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