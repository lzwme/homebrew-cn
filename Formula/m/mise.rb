class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.8.15.tar.gz"
  sha256 "f544f01381a42e4c7225bbce99dce876390fc6c45dd4697fbca2a47b2e0b4e0a"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "7f3bbe5b68ee55f58643520732b90b8f7f4994d5b0ba6204f46db64c8660c200"
    sha256 cellar: :any,                 arm64_ventura:  "9dffc8708bc8d8123455a2f10430b9d5d4ac17acb1064f74f51b0f92be4b141a"
    sha256 cellar: :any,                 arm64_monterey: "9533f23dff7fb1f100e473c2f9cb7912e8cef7bf81fc0336e63d31275f4479a9"
    sha256 cellar: :any,                 sonoma:         "6f04af7b358d649010b5d9ea2b333f55ef5d7880d6206687e1c7f980a24e79ff"
    sha256 cellar: :any,                 ventura:        "e1dad9e1d944baf39513c37795cba29b5a0350a4489eb748916dd2309887a670"
    sha256 cellar: :any,                 monterey:       "1a63eeb12bdf4960f6f7667179cca9851d85d0c95892366bc749967e8ebd290a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ec4c1d69ee54a93b727b4bea123c3260d28db2591177d929b036d5eeca73166"
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