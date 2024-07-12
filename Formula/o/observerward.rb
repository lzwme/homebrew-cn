class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2024.7.9.tar.gz"
  sha256 "d41bda274d0572df8062c31effa3f93c35ce7c8409297ee6157b4529de5f6332"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0b56ecf98b626ddd6866604d8d3483690638da9eac4a6fd36ca255df84b82042"
    sha256 cellar: :any,                 arm64_ventura:  "df58e660e73c95c177b51d0ce09aa381853ca45c3e46100e6531544112ca385a"
    sha256 cellar: :any,                 arm64_monterey: "a7fc2d417713b99469f3d01b439515f55982c05c4ce85691467e1fc73c8a7c27"
    sha256 cellar: :any,                 sonoma:         "6dd5a07d19ef217f94f7a194e0aa51752505805757713053ffc2eb0894f2b981"
    sha256 cellar: :any,                 ventura:        "723d3a60b62e4e7bdada9c2add468e09980a1ea86c9aa34fccf30d46d740059f"
    sha256 cellar: :any,                 monterey:       "d86ca69695b2b8469739ab5a0c6bf3c2ee65f87083ea16da7101fbc3e55d4fe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe44c3685d3b7ac846aef603f887afe0b746792b70cef6ebf933e046a6a58e7e"
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