class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2024.7.25.tar.gz"
  sha256 "82c4420270b0322d1f1f31bcc9e46a9a2d5d105c802a4134537a202058c48849"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5d81cddb3af5ec867647624118992f145ef71368065479bf7a227bf4ca560cb8"
    sha256 cellar: :any,                 arm64_ventura:  "0775ebb5fdb97c67eb9b4e966e75112d361a9c44f3e24513911e2292ee659472"
    sha256 cellar: :any,                 arm64_monterey: "eda9f0b3ddf7f81fb6317618501c1e01069d1a351b3b0f124b5917203d84585c"
    sha256 cellar: :any,                 sonoma:         "0b385019fb81d2a9622254644892c7c20870289d205e9c4549c7ef7991c3cb0b"
    sha256 cellar: :any,                 ventura:        "32bb16088ff84118a480f6bbbd9965c3003c57a62f2a41aad245ca3731cfdcf8"
    sha256 cellar: :any,                 monterey:       "f9513dc8a9864fa905c1f53989d427043f8320f82a3764bc73724c38840541d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19741a8b8b4914c882cb3ca54a2b8f208e32c5bbd2c4c86dad79875482cb6dc7"
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