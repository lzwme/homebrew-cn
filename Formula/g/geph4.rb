class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https:geph.io"
  url "https:github.comgeph-officialgeph4-clientarchiverefstagsv4.99.18.tar.gz"
  sha256 "00c72158596e62fc03a0dbcfdc28e38a79376ffaa4b046077e552a824092a28f"
  license "GPL-3.0-only"
  head "https:github.comgeph-officialgeph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a91201d06b3f27224495d7613b2e331469d11f4cc8debcdf97eba39ad7e4e43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0f463fc67d4f55f5752312bdedb26082c0a4835d75cb94b49ba83938fe7a43f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a17c643b90c907e94846e64d1a3d4653219e76aebbdd971add9ad539d7385f56"
    sha256 cellar: :any_skip_relocation, sonoma:        "58aee9378eb98be0ac99bcb1f69d60f097b7e3ed907a118572312ca71698d2b7"
    sha256 cellar: :any_skip_relocation, ventura:       "8f093913c733d165920d93405580600e4fe0cae8620e43254a8be765ac41c67e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edd904b6785f6ffa3289acac9a216df6a4ff0e2561440358dee2121dcbdc25eb"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
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