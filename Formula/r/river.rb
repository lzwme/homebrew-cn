class River < Formula
  desc "Reverse proxy application, based on the pingora library from Cloudflare"
  homepage "https:github.commemorysafetyriver"
  url "https:github.commemorysafetyriverarchiverefstagsv0.2.0.tar.gz"
  sha256 "32201e9b1e7f8072a4f96ccfb0ce06006115700b1b495477e4519afcda4c1bd3"
  license "Apache-2.0"
  head "https:github.commemorysafetyriver.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c0b14e58da260e0f2f4234fa031190de4678d2bb8c95e9c321e23b72c8cffcfe"
    sha256 cellar: :any,                 arm64_ventura:  "00e8601070d12bb88a43cb84efeab8fdf49f2f5520f5d9792851efda9bfa885e"
    sha256 cellar: :any,                 arm64_monterey: "70119ab06938669f746a23de17161d5ae9c8a1a59e8a32d0f705684b13d0eae4"
    sha256 cellar: :any,                 sonoma:         "8db2e9dc0b5ed09fa93fd5439907f1a0c049bcd1e91fd4c02e02f994e4490792"
    sha256 cellar: :any,                 ventura:        "9b2daa78ae9ff051882a946bde89d6c2e82deb1bb7375b311b0f07b20f0713e5"
    sha256 cellar: :any,                 monterey:       "1624ffe66adaf07c0f01ac4a3f03439c903628559fd889ff274087d7f5912e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebfba898ca1b62afdecb1e9b19b13c0119c75034727e00053a00dab629fdfc03"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "sourceriver")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    (testpath"example-config.toml").write <<~EOS
      [system]
        [[basic-proxy]]
        name = "Example Config"
        [basic-proxy.connector]
        proxy_addr = "127.0.0.1:80"
    EOS
    system bin"river", "--validate-configs", "--config-toml", testpath"example-config.toml"

    [
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"river", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end