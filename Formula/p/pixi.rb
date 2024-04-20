class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.20.0.tar.gz"
  sha256 "58c8ac8010c248c18ec1e68777ae48aba6bc54876a82f76eba9addff7169be4c"
  license "BSD-3-Clause"
  head "https:github.comprefix-devpixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6d43f69ed01ebc8fea7f80a985434660edf7289836e62b118517217c49d0bd23"
    sha256 cellar: :any,                 arm64_ventura:  "a2feb6b43e8ec92236ae117f5f9d535d1037c0ba151c1f5c03a46c643901a117"
    sha256 cellar: :any,                 arm64_monterey: "a9ae35b30a10ed661de767d8a66fdc42369ed7da9659e1b0c871f4c689973632"
    sha256 cellar: :any,                 sonoma:         "e7e88d502f46c8fc1595f2f40cf2ab7b2d24db64a1fbc418d443d947a89c0b3b"
    sha256 cellar: :any,                 ventura:        "1cfa5d273e27324ea0c22ab58cc9b98d84bd10e325c3f043e05b9cd23dd157b2"
    sha256 cellar: :any,                 monterey:       "7f07f8fa685e27647a9fa76bfd3c77f0a821a0d38bc5b3c2a097db6663466468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d60085f229e85f5f77f183f1efa59eece3f8a2554abe826954b99886a5bde796"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"pixi", "completion", "-s")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}pixi --version").strip

    system bin"pixi", "init"
    assert_path_exists testpath"pixi.toml"

    linked_libraries = [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ]
    linked_libraries.each do |library|
      assert check_binary_linkage(bin"pixi", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end