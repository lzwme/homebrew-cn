class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https:geph.io"
  url "https:github.comgeph-officialgeph4-clientarchiverefstagsv4.99.26.tar.gz"
  sha256 "ba1080997474db2adc3e072864c30f235a1dfabf2815f889050a05ecd42eae82"
  license "GPL-3.0-only"
  head "https:github.comgeph-officialgeph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12b2dbb024c7180e716aa79194543a6b214e6838d2078142668f338d9dca70d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f832e93ebfb22f87a9d7267144bb7bf72f29a9a9c5a1641ed999bebd163cbf54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfdc66ae97cdff853b054c00c703a3f1b11d6a82635dd961796950e26f53b71b"
    sha256 cellar: :any_skip_relocation, sonoma:        "df4df0c1ab1856b4cc3277d224da7062065cee683c9e53cff40418170a1da40b"
    sha256 cellar: :any_skip_relocation, ventura:       "bb85d2670018b336824fea64bc8300966c340da06ccf2c3fb502b3211d49ac2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f164c96a38e5564bd55ce4b9616b383bff5b7aec4bbab59606eb5f9439eacac"
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