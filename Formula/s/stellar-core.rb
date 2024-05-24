class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https:www.stellar.org"
  url "https:github.comstellarstellar-core.git",
      tag:      "v21.0.0",
      revision: "c6f474133738ae5f6d11b07963ca841909210273"
  license "Apache-2.0"
  head "https:github.comstellarstellar-core.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6dd2482b6ff4e12b9a2cfa8b3141d5291048a4c73272c321630e753e39cea11f"
    sha256 cellar: :any,                 arm64_ventura:  "77d3688ec1c6a729d858742bfa7e670c835b960cd99c957e414152150b5f8815"
    sha256 cellar: :any,                 arm64_monterey: "a7b62e7d47c376720f052bfbe3294ed27a0094d27a9a809236e6dfcd90e74417"
    sha256 cellar: :any,                 ventura:        "281132299639c7ae5f2fc7a3c8d7945d7d84856dbd9741cb8b482803f120de21"
    sha256 cellar: :any,                 monterey:       "f2317545fbf92e2879f4010871946f3b4fc6d31a30269d7c5356d267f990275f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "960f8e6345772a843a55d02cc28911be5f30449f5eb92a1a87e15604114aa033"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Bison 3.0.4+
  depends_on "coreutils" => :build
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "libsodium"
  depends_on macos: :catalina # Requires C++17 filesystem
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "libunwind"
  end

  # https:github.comstellarstellar-coreblobmasterINSTALL.md#build-dependencies
  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

  def install
    system ".autogen.sh"
    system ".configure", "--disable-silent-rules",
                          "--enable-postgres",
                          *std_configure_args
    system "make", "install"
  end

  test do
    test_categories = %w[
      accountsubentriescount
      bucketlistconsistent
      topology
    ]
    system bin"stellar-core", "test", test_categories.map { |category| "[#{category}]" }.join(",")
  end
end