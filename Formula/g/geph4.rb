class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https:geph.io"
  url "https:github.comgeph-officialgeph4-clientarchiverefstagsv4.99.15.tar.gz"
  sha256 "d3ad54543957cdf5ebbf4fe624456ea0552d000f8a966715c5f4ec6204eab2bf"
  license "GPL-3.0-only"
  head "https:github.comgeph-officialgeph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d01d4dc172d11c5ba0e1478c8a74f9e49697e823d9ddc7dc32a697048b2b4123"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47c710b42b11ea76bd034cd2c5143301cf461da44b3df09b30f2df9d4d9d25eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "643768050c3367a6650e9719e6b7a9b85b89f7a830cb0976ce1bda8594ce0d0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5850a3338d9466fec25717ba9941131657e040679b3b236ca7680efbbd5887c9"
    sha256 cellar: :any_skip_relocation, ventura:       "3bb590aa0019886d44cfceece1ab12f6cce9b054d7c2eea54b74f692e87a7d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5173544d6defd05d51cb4cc08ad284771fc504f3b20df48f2e153b58d35d47b"
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