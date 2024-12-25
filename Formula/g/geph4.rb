class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https:geph.io"
  url "https:github.comgeph-officialgeph4-clientarchiverefstagsv4.99.22.tar.gz"
  sha256 "2e8e0b7bea6d98e54c86c960bfaabf937dfae2f6bd0b4f929ed8963516c38d97"
  license "GPL-3.0-only"
  head "https:github.comgeph-officialgeph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec570245fc181d16c0244c92d0e819f2c6884c115395aa6ce602179c764b3a04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10bf5637bd06b382971fd8cf13ab5db96123f8f7c6af916f630158c5c22b019f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4c187cd6e52f2dee995a0464be86ab086d707379dedb9b36f0ee6b3fc1439ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "9832511464d39ef290bf0839765fe99d11fc0ffa523121bdba0cefca03a2281b"
    sha256 cellar: :any_skip_relocation, ventura:       "f24599d3545c4db091be8c4a55cff01a269f442a2cbba91247a2856e11620b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a8a2df3290ebe1aad5e1f2638a9a0a41ddad9fd9b771216002c9d4b2bc72c4f"
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