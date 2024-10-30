class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2024.10.29.tar.gz"
  sha256 "b2cb45e2d564e4e0a8b3a10c38971bf1907e2ae90438e6370aa687545715eefd"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a3c874f1852dc33bb7645cf32631401b4691c09ae614a184757fc2bfd5d6f4b"
    sha256 cellar: :any,                 arm64_sonoma:  "352a7842e2b58ff94887b09d3b354fc3d652922f3bd980b0834694f761691c7a"
    sha256 cellar: :any,                 arm64_ventura: "bc38a9880ca00d8602477cfb3c1ac06c341a72bb52f0abef5726c6717a672d16"
    sha256 cellar: :any,                 sonoma:        "7c8258c75f3c36737b36308f115dfb8d0738704dc028f35bdad73f9bad2698d9"
    sha256 cellar: :any,                 ventura:       "2a52c94c7a9b09fcd22e87269fb145e9775152f97fa2c55440c81f6d9930a285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8725b9eaccd9a3b714d4cf720b8b394d177f31bb427e00d13cf107d157673bc3"
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