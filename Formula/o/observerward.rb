class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2024.7.22.tar.gz"
  sha256 "50a2872b38280f2e1e64724ef12aa249c94f9e8f43d3d153911f00e1341fc81f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2ad4f129dabcbdd862f3a540c69c957adcd9a07f18cc1076002bf9b564411cf9"
    sha256 cellar: :any,                 arm64_ventura:  "e0df46f7a5b5bbb2550b0e4b46c112793242a9d3407ccfded1e6c56a9db0e6ba"
    sha256 cellar: :any,                 arm64_monterey: "7dd0e012597b6e0af72684bca46892558fee4606fdbf3490995d6b7e71264a2b"
    sha256 cellar: :any,                 sonoma:         "fb2cfd6e698de64be3c81e1ebd1efde3dae4390617d1fbef857c44459dd140a8"
    sha256 cellar: :any,                 ventura:        "69dbfdb80eec04d1288ca0d3626452c661364209f2d75d38614bd9513e52c6aa"
    sha256 cellar: :any,                 monterey:       "f3e1de0b020ff387dd143882bc40e26ef189258d8c7593e2b0c179aa06328d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "234ea110097f6de29d0d8263fb3d94e9876ba2af2fb7b3b2b06a543fd84f0008"
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