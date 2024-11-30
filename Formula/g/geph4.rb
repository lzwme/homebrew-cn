class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https:geph.io"
  url "https:github.comgeph-officialgeph4-clientarchiverefstagsv4.99.20.tar.gz"
  sha256 "e30d0f3d03851b502eb200d1fa62b74b91a8695a5079769cd04cb6d0543c0c19"
  license "GPL-3.0-only"
  head "https:github.comgeph-officialgeph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdc0e98a2ad5595d54d6d0a198731b92a7be977dbfd79fe59aca720535cc1de1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfaf5bc6e6e9e05a368c13e3cbe7ad16c6b0fe597ac8bd70e7d38569a1c4b0bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec7c5ed3a058620627cd57c2db253c19a5b45596ea7d7b981f3cda6abd5bb52a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c1e7194c05a848e947ee688d6eb5d52aaae9be3ccbc25f41d02f9276bf7d52b"
    sha256 cellar: :any_skip_relocation, ventura:       "eb71e811451e484f676a19cc2886b62582ae1ea54a59afbf7c22da9f2b277828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f640502ace9fe4d07a5b2b36dec76e27256d77d8c0811b1b30c4a70bcc924006"
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