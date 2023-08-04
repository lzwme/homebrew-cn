class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://ghproxy.com/https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.8.3.tar.gz"
  sha256 "c377c4257d229fcf42e1b4082eb20990ae65ccda2b57a6e66907c3ca37d4d967"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d37a80204608cde95754f7bdb5e7cc5e98d5f7ecc07c4a3a8ce4519c8efe92f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b76b15b3d49fa946bc9f48c4933997bd6386e84c1e338c5cc0f1cc37c20dd1c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "510c5f4dacd544e84382bd48bd866954d2b41be49396be5c333190815ac9ba3d"
    sha256 cellar: :any_skip_relocation, ventura:        "62c9329175867292171227292934b08acb480c7c2f7dcc73ca57a08c116e64e9"
    sha256 cellar: :any_skip_relocation, monterey:       "09276b4c9787a97bac5eb14e654221185b59ae968eee0f34154be4e1ca7dd477"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2543ba8a33a838a3813029289f86019a1211e78d03aaf3ea4d962f18e605cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e5716553a3378231e6614b027bb4c53a2cf7fc5f2495333c5251eea6232d539"
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