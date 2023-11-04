class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://ghproxy.com/https://github.com/geph-official/geph4-client/archive/refs/tags/v4.10.1.tar.gz"
  sha256 "ab464320196fdb57eee8e105cdb9a60b8769d06db92eb4f496cf3277e669caeb"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a10a9e02c878c3e211b2910033b3d7e853f65fc53d90b0c10d6c47f19903f679"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ad6dcb55eb8b5142456f5253efe82d4874ea635f9ecd703f1308c965ffb5fb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abdcc7d9bd8ebf048206e7aaa29aad0b9a448d3c826344dcbb2195a665e1fa80"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1f1323efb9ac3a1618fa001d7aba65ccddf255d07122b05816aa961b8a69471"
    sha256 cellar: :any_skip_relocation, ventura:        "ffb6a0f237a0cc7a3e31d08b5d658319ce4e4e73890d3ae93e1f6c9760264e9a"
    sha256 cellar: :any_skip_relocation, monterey:       "a893ee15767b0c5362e0c96a276d2aa384908d1efbe3ae5a14e5bde25b01463b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "733b0d310b1d8f22614d7e8ab0044b31cda280a0728c42b8a9f8bf20c8e4596f"
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

    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid credentials",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end