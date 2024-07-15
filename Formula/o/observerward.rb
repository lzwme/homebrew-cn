class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2024.7.14.tar.gz"
  sha256 "8c4752897e1ad8ea32ca4aedf28b80b3089911720d5c8cf4a0c8d01fb044dc6d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "01710ef5cf05b82587a084fb5990de80974ebfc3d270592c8d42b7849635adcd"
    sha256 cellar: :any,                 arm64_ventura:  "53f722d6030d608aa6b786c7065b2451ef51336476322525eacb856fec51d1e0"
    sha256 cellar: :any,                 arm64_monterey: "33ed90cfeba82004d4f57b4f5601551e435fcee52cb72892d9b78a144ef682ce"
    sha256 cellar: :any,                 sonoma:         "593c841c0767a3b634b954d404e7d2204002508cfc4c4a4215d393cb52658c21"
    sha256 cellar: :any,                 ventura:        "fefb1cecf1f1965cb17dbbd14dfd4a329be889f7ef7470be2057ff70fbb8ce28"
    sha256 cellar: :any,                 monterey:       "f689de448763f32e4818c498ddb23768f05dc665720fb817f692a9609e3abcd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c4c053c5c566a21ec998e7d776643a4337264130f66ea8ea1e6b914e134fd8a"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}observer_ward -t https:www.example.com")

    [
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin"observer_ward", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end