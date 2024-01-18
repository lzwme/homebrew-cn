class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https:github.comdanobiprr"
  url "https:github.comdanobiprrarchiverefstagsv0.16.0.tar.gz"
  sha256 "6b47a78449332bd2a06be4e18e44391755cd50751961440eeaaae7d3b920cf0c"
  license "GPL-2.0-only"
  head "https:github.comdanobiprr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bb7e4ace8ea0a1551f5ed11aa2165110b9e72ac1e92b5bdd03c5772d5a6929c1"
    sha256 cellar: :any,                 arm64_ventura:  "60158e6502d7853c51b2a5d7c2c263caadd5b0192e90b250a36af3136033691d"
    sha256 cellar: :any,                 arm64_monterey: "a7c72935a3be1735442d781ae3b136548f483bf0e67ee8fb1eba44e160b458b0"
    sha256 cellar: :any,                 sonoma:         "e536bff238a621b52afe9936661d78a9022e57b8087447723ef560148daee9b5"
    sha256 cellar: :any,                 ventura:        "a3b5f9b8fe3aa15c6a5ebb27567bd01bb0f38eab726490a50971616ef9ffb2a2"
    sha256 cellar: :any,                 monterey:       "277aee025f37ed2f1f11197fc42f82a137e8f0c9d8659c1cfeea918d1a2eef41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c48bcae4a54bebc73168f4478b81fb83c3d94156f995fae33d72a5370e7a2a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure the declared `openssl@3` dependency will be picked up.
    # https:docs.rsopenssllatestopenssl#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Failed to read config", shell_output("#{bin}prr get Homebrewhomebrew-core6 2>&1", 1)

    [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"prr", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end