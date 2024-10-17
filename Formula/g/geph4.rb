class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https:geph.io"
  url "https:github.comgeph-officialgeph4-clientarchiverefstagsv4.99.9.tar.gz"
  sha256 "ca7be73b5dedbfdedb6eefd1198b30ae5aedbcf0a8b9b99c7604d3e330358031"
  license "GPL-3.0-only"
  head "https:github.comgeph-officialgeph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51dcb8109f30fdafb4970500b2640df7e589c7872b6edae6f746a47b0a028ba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "943ef7a7bed787e0fb3762fccf21dd38c37ed08fcbbee61fdbf721a67fd8a97a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10090a65edbfda2a650acd92bc8027f7835d9257f159fe085054d8b59ca00803"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fbb2ce16e7cfc723914a38fe966b197b24f15c26606e0229b4c31812944f827"
    sha256 cellar: :any_skip_relocation, ventura:       "f67226fb92b46fb871f828d0d184626664a911cad82f039a746763fa89edc62c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "687f7cc21377767817e79a858a3f35abb8107dd281b8ab52e314fb4289166c71"
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