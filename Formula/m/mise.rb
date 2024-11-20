class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.18.tar.gz"
  sha256 "43ad97a8276b1d57cc3934d1d8d5dfbd2ff8c7c9f948cb1a9885833ea93a7504"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7e97aef3e1877f4dbcf44b3034c96fff284ab77ab62d94d278266e91ee2fcbe8"
    sha256 cellar: :any,                 arm64_sonoma:  "c5cf2dc314464f4e786b8f6b412e6abe4ddc5f6979b751cf3092b6994347d0ca"
    sha256 cellar: :any,                 arm64_ventura: "41f5f15a8fedffcb096e8855cdf62d2b5debcde51cdef2bd5db3397d82909836"
    sha256 cellar: :any,                 sonoma:        "e74ff0ed9dd91e9b334a07e8e239f05fbf70b5545ad51e2571cc3887e994b7d8"
    sha256 cellar: :any,                 ventura:       "9350ce70f17494ab9ae565d64591882480393b5b65e99873e8b49c337bce919b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33b7537bf920898960bf9650cf97ff13776fa9035af26deea0ac187f205bfe0b"
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