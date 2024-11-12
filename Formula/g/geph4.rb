class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https:geph.io"
  url "https:github.comgeph-officialgeph4-clientarchiverefstagsv4.99.17.tar.gz"
  sha256 "61ea8c4012add252ae24a67708d42d0ccead34250d203fcc86e43be642a40ffb"
  license "GPL-3.0-only"
  head "https:github.comgeph-officialgeph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2165f1f7fbeecea656886ce0fc3437533bc8b85f770b5234003c3dc09ad74df5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f65f3138fe0d85447d9f1d9fdb74c784eb836d1693f79bc035a2b48b40cb467"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0344932fe7d4e0948f01afe749e424f3dfd460b964e0467d4c0ecaa6f628c12b"
    sha256 cellar: :any_skip_relocation, sonoma:        "62aa9d85ddc7d1349c3378720eeb1390b5fd5951390c1b42b03044d9f5587b40"
    sha256 cellar: :any_skip_relocation, ventura:       "cbe7cd3896d8053d2534ea6fb9f7a1c75b82e7aaba7a8c7a299501ba4c1838d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77dbd006d6dc83b9187d0e67263515f82e4522d298eed35089543d08c19dacc9"
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