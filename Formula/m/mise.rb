class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.10.11.tar.gz"
  sha256 "7cb2edb3637f7cb100446a498c0cb28c3436de1bac64b87df9d8502ce8d18bd7"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3d1ce9664736b5039466ceeb8286f87150a220d76cf62e5c5538ed4c42c01ff0"
    sha256 cellar: :any,                 arm64_sonoma:  "d28afbc2017aa2d5904da9ca14e1fc9d01d341bfd0adc5168ace961e326b5b1c"
    sha256 cellar: :any,                 arm64_ventura: "c4005d63d073861cef944841aa88925b1b929bc150d94bebe65322a4c7a6886f"
    sha256 cellar: :any,                 sonoma:        "d392eae34949295556f9c3598ce97bf44f5392b996b02ea31956169332a41f1c"
    sha256 cellar: :any,                 ventura:       "fd1afe999715d971c78f4bfa90b74fae7b7f8688477b07ea89c67ee36ea8463a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22601cf4faf8764cf29d6cea72ef0e0789b10da581d899a229aace4e0069b2c4"
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