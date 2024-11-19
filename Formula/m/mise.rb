class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.16.tar.gz"
  sha256 "c38f06c75d5dfb5ab0a67888edaaac19f55037c9391190835d83e48be02a75e3"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab1f60222bb03a3a9feaa2192a4b81a6a276f35ae2cb34f09a0acd191102f66b"
    sha256 cellar: :any,                 arm64_sonoma:  "81720c125c2504f1308e1ba688ec7c3ef6464f8fab8715b8398ba9ca7756dff8"
    sha256 cellar: :any,                 arm64_ventura: "ba7068e62a0c76bd810943b55a36f41afe10c341fe13d9ff00ab1cbb40c62996"
    sha256 cellar: :any,                 sonoma:        "644ce3d78101801f303acf39f5335ba8c6d6f18684f9a5b55c11227ddc04b468"
    sha256 cellar: :any,                 ventura:       "e897f4904f32e74835472879d56433cdeb0f2f107894657d828919aea19357ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "560e8d7f2cbf896155f5da59adb810a9ace5a38622b32adcff2371b40bd2cbd3"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"
  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "xz" # for liblzma
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "manman1mise.1"
    generate_completions_from_executable(bin"mise", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin"mise", "install", "terraform@1.5.7"
    assert_match "1.5.7", shell_output("#{bin}mise exec terraform@1.5.7 -- terraform -v")

    [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end