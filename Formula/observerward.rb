class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://ghproxy.com/https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.7.21.tar.gz"
  sha256 "f7a35e2269e78f274e229b229e9c3a4ffd79bc305ac737613a5dda179066dec9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bc039cb89234a36b334eebbe17128d3bcc0cd2416c60480e99beada4f8ff6095"
    sha256 cellar: :any,                 arm64_monterey: "bafeb5fdbeb3722414b0340feea55b155c9f82ce8e6b528379750c86eb763456"
    sha256 cellar: :any,                 arm64_big_sur:  "38994e413fa497074a2c371908299b276bfc3535af491cfb05f5581f8d38728a"
    sha256 cellar: :any,                 ventura:        "7f02f5c7823721b867395e1ff0a86ee84116cf897a4c25bf7afbb731b859d8a1"
    sha256 cellar: :any,                 monterey:       "f36cc74cd44022d039c1a66d75a67fefb658f651e6f9b8db30fbea04d6e86b3e"
    sha256 cellar: :any,                 big_sur:        "f521efb1d9bcdb72a7bf8537dfa8205e7f309794d48a9efdf43baa24aaaf0095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6cdc4eaa55a1d8da90bc9469f869eec74c6eef0930bb717a7fa8858c7175a10"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")

    [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"observer_ward", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end