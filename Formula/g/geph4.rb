class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https:geph.io"
  url "https:github.comgeph-officialgeph4-clientarchiverefstagsv4.99.13.tar.gz"
  sha256 "96d70f0a0c82f1b259e8e3203e69422445b249b967e2d67c08b5171321c7a692"
  license "GPL-3.0-only"
  head "https:github.comgeph-officialgeph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03c1d62fa10a08fb83523dadf87868e1bb3aa631615dd98d4e7d59cbd51e32d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c75c1acd89b506940e76150e901c207aed81d1f1cb0035c0629bf463fc37030f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad4034441d3feefc6e86347bb11ae4926bb743a2f8a23cdd305e447454aeffca"
    sha256 cellar: :any_skip_relocation, sonoma:        "6da00947d1ed069ca6ac457db7d688f34eed11f735c28350e9a0923680d7da8c"
    sha256 cellar: :any_skip_relocation, ventura:       "7d748d9407777a06dd152fb1e224c2892506281765796c503fccc51ef0da5ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a1cb6a39079930de96c3b0825dff016ac6f275437074f0d8b3d80c2eda1f67a"
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