class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.9.7.tar.gz"
  sha256 "eb477074c4ade48ad7aaa1424be8ac7a82101c3d4e05f3c3dbe76640ab119f1f"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec9cc303f7ab818b7624c1e4adfcf2148b3b0fa1d9de347195f88c4bf56b6246"
    sha256 cellar: :any,                 arm64_sonoma:  "ac5597f77173844a467525525eae79ba19186ba41026ab61bc1c329516cb02fb"
    sha256 cellar: :any,                 arm64_ventura: "7d1eb3cba753a2ab0683d5df396a2470d6e9628d58eb78baf391ac46a0e9c7e5"
    sha256 cellar: :any,                 sonoma:        "8e8d6894e949c5916ede14a980dfe096853c1cbf810c263bb362792082bdac1f"
    sha256 cellar: :any,                 ventura:       "cbb73eb28e4df21c104055befe29d6512bd877d6cf4106cc2e5866e7f486ac71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a3782787966fee21e9610d27e732d8145da54a66a329f125435969a1ea3939c"
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