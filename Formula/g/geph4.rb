class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https:geph.io"
  url "https:github.comgeph-officialgeph4-clientarchiverefstagsv4.99.6.tar.gz"
  sha256 "acc8cf566dabeb9b3c7c7f87ad8ee5829c29299adf62c6efb90649155ff93e23"
  license "GPL-3.0-only"
  head "https:github.comgeph-officialgeph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7abc3643e3a35cd857f60027a833c961015bef866658c711e1c5c2d6f8064708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "532f484f37db8b8ab8abf51945ad08a9f70cbe7dbec32d90930e89f3d13eb854"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77563f6df4fcfbe9a6857670038e0c20c3e03a550a28ece8fb1b246b1ba0e134"
    sha256 cellar: :any_skip_relocation, sonoma:        "226bb64628a868d165f8d48b552c8400c9b89d930588fb676c831a7d5201c24e"
    sha256 cellar: :any_skip_relocation, ventura:       "c4972bf03766343d265e7e31822a13b3842e367e12a4a3c283a8dcc12507566b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b8248137d3de995458973c6cf80f6cf3b9e07fd43950e0d2b81dd762c064a05"
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