class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https:geph.io"
  url "https:github.comgeph-officialgeph4-clientarchiverefstagsv4.99.11.tar.gz"
  sha256 "ab055eb451e3260337d8bd92e35eef4593c224cf03d9d7d3a69e63ba59e1ba71"
  license "GPL-3.0-only"
  head "https:github.comgeph-officialgeph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7b8c21f735947bb8d17fe195d0205b395972766f49f33b1617911ab8975d509"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b634012695757f76a8aaeb51b4416a8b07dee83b1c86ad80afe96073acdd6b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5526d722e626f00c2e23883e11a6bf29b946ebc410e9ca6a5b0d6ea891a54e08"
    sha256 cellar: :any_skip_relocation, sonoma:        "717082da547c73ea917f5bffd4a895bb93979a956bd0aa473f31f0d9c609fc24"
    sha256 cellar: :any_skip_relocation, ventura:       "2184ad3304d5aa99275905808ccd244b0367c1e8c9bb488cd9fb46d06c05749c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5083e84f6a88993b79df1b2dbf2f93d738b0438ab09e8c8447a5a0897661de94"
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