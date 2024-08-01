class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2024.7.31.tar.gz"
  sha256 "a0a31371e6551fd36f69091b67b096ea5f4204e98fa0508a07253ee593641b34"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9e30b61b6161557fc35728520f9848f05eeb34883a9cd4a91349184a3b52e9e3"
    sha256 cellar: :any,                 arm64_ventura:  "0b4ff45313f380eb37b96cf4c5e9543edf8d2429b13b535877458b052caacce5"
    sha256 cellar: :any,                 arm64_monterey: "8cb4cee5edb12ed63c1c624ef60e1865794fe1659f6440ff08c8d5658122fb49"
    sha256 cellar: :any,                 sonoma:         "a8cbd9efbffd65daa55b1af84bfc3be8d8c77fe637146cd4c1843efe5f26cf2d"
    sha256 cellar: :any,                 ventura:        "c7282db4efe10770c6106e06e78760474780204a5c2e71deae528d1eb36865e6"
    sha256 cellar: :any,                 monterey:       "724408d9fe853358320def3f78e220d0e1a7f5756e557367a74a91aa2e22cea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d34341e2ebf16d396335a28e7d853477753c37e14585b5a4aede6488757d83d"
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