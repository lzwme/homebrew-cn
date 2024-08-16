class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2024.8.15.tar.gz"
  sha256 "fb45a506ee55f49a35358300c256db22e9580d283a25d0c11aa6940f190bd07b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e2d8a0b1c5cee2359e1719d112710c7462d2ed94bbf6dfd1f2f4b071b31b8b98"
    sha256 cellar: :any,                 arm64_ventura:  "4cfdcc04a5061908e70a770e6e546b3fe356b78f47683b61fbd16db6935c65f0"
    sha256 cellar: :any,                 arm64_monterey: "c8987d429fa2552b1dfcc0a7d7e94bf8fc7666cab42522499b84e909520cc2b9"
    sha256 cellar: :any,                 sonoma:         "1df97956af8d92296b4a1657076b560621d1c10177d06f5b1c6cf1b93cc0d398"
    sha256 cellar: :any,                 ventura:        "2a209fab997315122eb94b81d33f474fb10a86ecf59cbefce04c704eb6d98fdb"
    sha256 cellar: :any,                 monterey:       "2465f37af26a2d5256329a08db93cb09cd83e66925aec63764c60f314274bfd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc085a3f4078bf26213bfa0432101fd77af2e88b27f1e608bcc76e1ed08f496f"
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