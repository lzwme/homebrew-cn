class TmuxSessionizer < Formula
  desc "Tool for opening git repositories as tmux sessions"
  homepage "https:github.comjrmoultontmux-sessionizer"
  url "https:github.comjrmoultontmux-sessionizerarchiverefstagsv0.4.4.tar.gz"
  sha256 "9dfbe99a3c1fe7f48be0c1ab9056e49f36c4f85d023e24f874254f6791a9894e"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4042bf4b217a95b253ea859c8c4426950ec8b0653fe873f8b5b2624399e36186"
    sha256 cellar: :any,                 arm64_sonoma:  "6d78bca70b4b810883e57ced9e19de3970f44e4817f7fc344f64f15b9c2598fd"
    sha256 cellar: :any,                 arm64_ventura: "768a4b4e6037be396301f0dc9f121134034bd6388e800df6b3f68d1acc3a397a"
    sha256 cellar: :any,                 sonoma:        "a50d45fc6db7c4ce2f5190900adb7f278635d58dbdbb844e39c3d99f1dcea374"
    sha256 cellar: :any,                 ventura:       "b209c7ff2dd2e36422eda390fd21cab761b44b0378727de497068f9b8327c533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67cde82247503f1f870cfe96d88e70a55c91edbb14fb25cdc2098a90723f8ae1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
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

    generate_completions_from_executable(bin"tms", "--generate")
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
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"tms", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end