class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https:geph.io"
  url "https:github.comgeph-officialgeph4-clientarchiverefstagsv4.99.21.tar.gz"
  sha256 "48993490853adfc9af2e3e97d74f680b857fd8d16ce433ad1d231888f3577d93"
  license "GPL-3.0-only"
  head "https:github.comgeph-officialgeph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a48d15d07927f2565e49b35dd8f4c665d4694ed2c443638c90ea97d723e11ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3255970327fc2d5fcdaf650cca13f9a394d781e4c313c8f7c7826f59e8a6365"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d809a0b31b239403fb3c84a4f67247a28cca0942242960d9fab1b0e716006dbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "88192a8c9f6551de5343c53c0fccc46fbe62d67a86628c1910e0330c86a1d8b8"
    sha256 cellar: :any_skip_relocation, ventura:       "9cf7ee5c35d682e64f5db437f0c4c6b43f2627fd23faa6914bc53d60df0f82c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b100b1c5d6a0106c06b8803ba71f7593469ceda363fbca7c9b9768502aea46c2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    rm_r(buildpath".cargo")
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}geph4-client sync --credential-cache ~test.db auth-password 2>&1", 1)
    assert_match "incorrect credentials", output

    assert_match version.to_s, shell_output("#{bin}geph4-client --version")
  end
end