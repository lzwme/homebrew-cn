class TmuxSessionizer < Formula
  desc "Tool for opening git repositories as tmux sessions"
  homepage "https:github.comjrmoultontmux-sessionizer"
  url "https:github.comjrmoultontmux-sessionizerarchiverefstagsv0.4.4.tar.gz"
  sha256 "9dfbe99a3c1fe7f48be0c1ab9056e49f36c4f85d023e24f874254f6791a9894e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "039011d74739cdc73301f6d8d424311d14f14243bf9112c64d12668f303e94eb"
    sha256 cellar: :any,                 arm64_sonoma:  "fc7eb901dff1deddfc6cb6bf320b473154d3760459bc80cea477f0cfb95d147a"
    sha256 cellar: :any,                 arm64_ventura: "f4ce96fc1ad1def2e691bb9941d1b9017e5ff90797149f66bf29054548e6e972"
    sha256 cellar: :any,                 sonoma:        "7ad5de9590ab6392514dd65e4159bd56f7d8edb6708036a1f422cbf251c83896"
    sha256 cellar: :any,                 ventura:       "b86f4cebc829f1b7717870caa79f1ee5ff91388bfa09e00f13f4672d55e9d046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3f45a9334e24a1c2715a766b4fe387fb3a8ed737c7cf8e5e4837ef2ba27e468"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"tms", "--generate", base_name: "tms")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Configuration has been stored", shell_output("#{bin}tms config -p devnull")
    assert_match version.to_s, shell_output("#{bin}tms --version")

    [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"tms", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end