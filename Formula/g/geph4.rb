class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https:geph.io"
  url "https:github.comgeph-officialgeph4-clientarchiverefstagsv4.99.30.tar.gz"
  sha256 "314057ff0e31b14dd11204c30935bc1f81bba9d08da7aab2b3d9e5233b2fca66"
  license "GPL-3.0-only"
  head "https:github.comgeph-officialgeph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b69fcd90f1a55144243983bac0fef50e028be572f010849aeaa47af720f15ae8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "831f3f8f223cd1f9d8b69eb1baff615f97923fdf83d5b3381ad5eb65f25a939b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "489e73c15a9fe97ebf8dff498e3bc198f0663ef4c33ac233aaf415b3f36a4774"
    sha256 cellar: :any_skip_relocation, sonoma:        "02f34656338e964f7d9352ae2379fd6b16f9836d40de0eb52b37684052c937c7"
    sha256 cellar: :any_skip_relocation, ventura:       "062c518ade7707cd73a6100f07ae9fb224217b9de18defe9a05c238fcf3b8866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ae99e4245ecd251c4dd9b72e67a2ca1816893fd982eba339c0565dc92e93f0b"
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