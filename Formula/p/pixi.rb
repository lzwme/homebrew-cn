class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.21.0.tar.gz"
  sha256 "135ca80673a7913bee86a60e56b971f55702148c8b2e612f4c59c3a9821785fd"
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
    sha256 cellar: :any,                 arm64_sonoma:   "ce530a9fc4aaf03b59ec62b0ee150c0cfe543bd0a8c4ee52301f5bdb44bfc937"
    sha256 cellar: :any,                 arm64_ventura:  "f2d644f108f9215347824e8f142394b7ece48b99223fd2c295d7abea49058f4b"
    sha256 cellar: :any,                 arm64_monterey: "f3e751c0b4d83d54afb44739f2b9db344e91e36572975051e6fa78e7eed47f38"
    sha256 cellar: :any,                 sonoma:         "d4ba5d6e082cdd7851ad169bcf7543c70272b42228020ee54c04058054a1e891"
    sha256 cellar: :any,                 ventura:        "911928247419587297c0696d646f0ab95d3e2b17dd094d5924481b08efc8ead3"
    sha256 cellar: :any,                 monterey:       "fb09285b0fb044acd8f6d7c16ead8c94964c07768348089b9f38b9864a759a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f012a6ae8c473486ded61087a2af03a90cfd7b06852a192aab5fcb9d909f78ed"
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