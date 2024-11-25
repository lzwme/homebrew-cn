class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.28.tar.gz"
  sha256 "4fc25c563e4f904cb9b371b60cfcfd54434e5f2ad0ceb2cda68c17e2cce80864"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15e91422e61c8540ebd18acec4c3fe7222b6d418625570ccca61fd27387d78cb"
    sha256 cellar: :any,                 arm64_sonoma:  "911087c93ab3e089e1f0c399723603eb07aa23f72b01e525128027c74e13f548"
    sha256 cellar: :any,                 arm64_ventura: "17edf0c66b26bc7daf7d2c8ba8a27d9ea326263d33ddb708ab87db6203b28f03"
    sha256 cellar: :any,                 sonoma:        "1a88001e3140cdfc9b84a74f10f77c97003c9f6bcb2a719bd8779a24a4d9b366"
    sha256 cellar: :any,                 ventura:       "ecffe8250d510ecefd9b4028b4d3fd6de9b345ab23e19e40089efdcd4bf7b724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cebe09bee2f98fec44e134bfac1d9f06f724b7a01135f4cce9bad4f9fa289c8"
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
    system bin"mise", "settings", "set", "experimental", "true"
    system bin"mise", "use", "node@22"
    assert_match "22", shell_output("#{bin}mise exec -- node -v")

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