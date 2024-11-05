class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https:geph.io"
  url "https:github.comgeph-officialgeph4-clientarchiverefstagsv4.99.14.tar.gz"
  sha256 "b25c7212183f53c87640bf02a803c9d7ca8e4d535b1ca3b645fb5fb3f2705133"
  license "GPL-3.0-only"
  head "https:github.comgeph-officialgeph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afff3fa0448ffa6fedfdc7194b7eb874469f4e0c872e31f76f64f1e1f7dbe932"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5e795cf710eb54bcf76200508e5c7e94687e09624d390462b31f201a633bc98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "231efa6d7e2673154c221d60d4a7985299d51163ebbe226772c2a835b6a69312"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef371e7bd9f18485ef126cfb1576100b7c0034cd85ce0efaec44c566eb19844d"
    sha256 cellar: :any_skip_relocation, ventura:       "33fe6116fa6fb1faa191ad63ac84ffcb9132234d29e52f4920004c5e9c4e94b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18d33466939a9b026a8585647609c09ff2caac057a5f41dfcdf4cb255b49d1a2"
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