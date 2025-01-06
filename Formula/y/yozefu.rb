class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https:github.comMAIFyozefu"
  url "https:github.comMAIFyozefuarchiverefstagsv0.0.2.tar.gz"
  sha256 "057109f56bdebb09b4f602c74f1c31dbed275d0d63f247b994090d64a98f4539"
  license "Apache-2.0"
  head "https:github.comMAIFyozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a2d0b9e15b95f8b15a4613475ab56396229dcd6b7011e73b93a94fe00ed238b2"
    sha256 cellar: :any,                 arm64_sonoma:  "26ced7f140f7a2db6577a04d287325010920c207e64d6848ad3dac67c07a8307"
    sha256 cellar: :any,                 arm64_ventura: "4509429f15b40d818a027b8f8d5dd484178353abf46cad2a5abfb4b624d81374"
    sha256 cellar: :any,                 sonoma:        "f80d5874e60f3db277c10893fde54dc93ea0df9af6e2c4d9f30356d5e7c0ad75"
    sha256 cellar: :any,                 ventura:       "32a7601f29c5a3b8ae2b06691e4904c7499db6dbbc2e84a0aec78fe98ec2e491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a471fc50a5de224f6e43c9ab89f7854933e702ffbdc0344cd5982c055294cff2"
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