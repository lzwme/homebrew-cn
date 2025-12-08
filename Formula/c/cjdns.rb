class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://ghfast.top/https://github.com/cjdelisle/cjdns/archive/refs/tags/cjdns-v22.2.tar.gz"
  sha256 "ac4fb3325a5f55c0f63f5c510e8cfef455b796a627ca19d44b0cc186ccce5b3f"
  license all_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://github.com/cjdelisle/cjdns.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f0ac066b9536df86560d40dd7b3a33062e5ca59977ad0662c6a3d565342e0f0f"
    sha256 cellar: :any,                 arm64_sequoia: "5aa5deacb035f54287065e9b60f93944875786253a2f3837ff665913e53c582b"
    sha256 cellar: :any,                 arm64_sonoma:  "05e3abe1b0c11b96eeb52c6df42df9ee41276a3051929cfc01c45af0c80cfa93"
    sha256 cellar: :any,                 sonoma:        "9897c94e1c9f31c12a7a4fa2ffade4733c6c4f57e0d241e13fce0d7d9f662eb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db6357a57817251bfaa64e902f5b3842d78d5b4100ebd07b6a4ebcaf82b28dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "182b34beab6c2ea705ea668cc02c382509fc8b4af46818fb99ac49456c8d04f1"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libsodium"

  # remove inode check, upstream pr ref, https://github.com/cjdelisle/cjdns/pull/1272
  patch do
    url "https://github.com/cjdelisle/cjdns/commit/4848490a8532c03d9918adf5ee7d28c66eb65fd1.patch?full_index=1"
    sha256 "4eb2abe4d52270018d8a1d1d938ee1323d9b1675f35e36f5c6bf2f0ba50a47e8"
  end

  # patch to use system libsodium, upstream pr ref,https://github.com/cjdelisle/cjdns/pull/1273
  patch do
    url "https://github.com/cjdelisle/cjdns/commit/5ac5ce94028d507041ab4f24d30184b2a8b49c8a.patch?full_index=1"
    sha256 "837f023cd073578282d2cdb217f8c8beece090abad329b1410de6976f56ca734"
  end

  def install
    ENV["SODIUM_USE_PKG_CONFIG"] = "1"
    ENV["NO_TEST"] = "1"

    system "./do"

    bin.install "cjdroute", "cjdnstool"
    man1.install "doc/man/cjdroute.1"
    man5.install "doc/man/cjdroute.conf.5"
  end

  test do
    sample_conf = JSON.parse(shell_output("#{bin}/cjdroute --genconf"))
    assert_equal "NONE", sample_conf["admin"]["password"]

    help_output = shell_output("#{bin}/cjdnstool --help")
    assert_match "cexec", help_output
  end
end