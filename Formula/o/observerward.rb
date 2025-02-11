class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2025.2.10.tar.gz"
  sha256 "f127e795acc1a5aac98d6d1ec5a152fb4a410df4d2590aa0c7b6b831164f5477"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "02c78dbc02255048973cc8b48aee87b9b0b48c066aaf1628ebdd371ad7583bc9"
    sha256 cellar: :any,                 arm64_sonoma:  "4b5a63bee192489c9d03e7c6f1f8230e9b6fd150def7426da665099d42937c38"
    sha256 cellar: :any,                 arm64_ventura: "d0d022724606924491b71edfe0315b565efdf95c9bf9fa57ed2ac56c58aa99da"
    sha256 cellar: :any,                 sonoma:        "23152c9ad46bbe07cd7c84b9d97a800c1cd636360cfc095d50a3994573c7551a"
    sha256 cellar: :any,                 ventura:       "03562f5c25d3c0c554f3976c6d5d326afc1410db4cf2b206238621b907a7f235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c11040dea0a5dd4e07706318b54ba503e0b4ca4f76c9f2929f96d1807427f00"
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