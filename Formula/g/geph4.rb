class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https:geph.io"
  url "https:github.comgeph-officialgeph4-clientarchiverefstagsv4.99.12.tar.gz"
  sha256 "d484b8f92a32a3da1b195958187baeb7f191bbef368344ff0268a516a550addc"
  license "GPL-3.0-only"
  head "https:github.comgeph-officialgeph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09c50fd16af06ae92a93c176ee1184fddd86fda1000d4ca2c9ed4ed5a147e8b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98f657304e5bce2ffc0add6151d80957c494eef5bacdf142dfe4dcdeda9f09aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e028ade3f783cd5db565396f26767080fe256381d8c77a1df37b5720ae325b8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2c3db73560efd4b3839ff9962068acf6d543c5a67134799bdb6c3774b10d316"
    sha256 cellar: :any_skip_relocation, ventura:       "77a7c38fcc42f9a8192875d6f2ae4d662fefeab01d2c4cba8a37a5ffa6cb0192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad01ac819ad8c74629c8ae695fb68800e09b99cf91a88f6cf5b9909f3522a480"
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