class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2025.2.20.tar.gz"
  sha256 "311b0015828901d9f04867c7039c4b7a6638c9b1e8c16b858d10de479fb61f7e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1fa648b37421a1e822233dcecf43f403ed625eeb1f010acb9f0ee44461905934"
    sha256 cellar: :any,                 arm64_sonoma:  "ec6063e65501660f33fb229d12a389924edf258e21f3a50cddcd637c6c1c43ac"
    sha256 cellar: :any,                 arm64_ventura: "e5013eecc8dc8685cdabcaea30c76e98411069858fe9caf384c169afb572b226"
    sha256 cellar: :any,                 sonoma:        "feb7015707adb829d1e4a8dd9fb8a3ab061f874fd875e8e43372e2c02e3eff9b"
    sha256 cellar: :any,                 ventura:       "b46a6c161ce78527c85f13f329dbbc37f2cdd2476fb704d15373a83e36526f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1620f98c0e92ad25dec97fbc8840cf7079c2d3e2ed03e22877b3273299649118"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utilslinkage"

    system bin"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}observer_ward -t https:www.example.com")

    [
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin"observer_ward", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end