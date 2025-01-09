class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https:github.comMAIFyozefu"
  url "https:github.comMAIFyozefuarchiverefstagsv0.0.3.tar.gz"
  sha256 "a31013c493d268a0db840f7c687df33aebd3187cf83d34939de7a819b78947be"
  license "Apache-2.0"
  head "https:github.comMAIFyozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e7ecd9ed35ccbe7eb210620f074f3aa78cc6fae4d8922820079352a7aa657a0d"
    sha256 cellar: :any,                 arm64_sonoma:  "08cd90866606b12245b42a4b6a21bf5155ceb8e9da387d0be09d039d0cff6731"
    sha256 cellar: :any,                 arm64_ventura: "4e77454ba41fd1e17b18a663f4a5992f95e482535a49457ad2e1781d49e6293a"
    sha256 cellar: :any,                 sonoma:        "fda4ac6587777172546ae27aa1b092ea7f57ed8ae1b9c2615c478875d3621e2a"
    sha256 cellar: :any,                 ventura:       "cba7bb64282c589dd29e20d62436237a3c447643a944a0bd787ec2eb4ec6a5ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05b2937f8a5d3eb05f2692b144d85904f36932657196571462564563014f5bb2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cratesbin")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}yozf --version")

    output = shell_output("#{bin}yozf config get a 2>&1", 1)
    assert_match "Error: There is no 'a' property in the config file", output

    [
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"yozf", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end