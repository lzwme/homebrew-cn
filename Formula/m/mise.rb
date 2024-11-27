class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.30.tar.gz"
  sha256 "eb9827c6db7741e86a2a398dd6bc7e144920b81169ee5f6b4025138316dbbdb1"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dbfc6959a4adc02774357a9a1067be3b7ee918b13477a952511fffff301f3595"
    sha256 cellar: :any,                 arm64_sonoma:  "29618a8e2b6216564bc615eda9f4e25b7851ad63db450f306324fc1edd50bc7f"
    sha256 cellar: :any,                 arm64_ventura: "39a1f0c35776fe1c5007f6c6d655bda5e10191d31b629d5099f7b1e47d63f88d"
    sha256 cellar: :any,                 sonoma:        "c43454d9b66ba9361e0c962f9dd1979b9334b4e3e1b0ccae0e9ca59a50b61a45"
    sha256 cellar: :any,                 ventura:       "8fb5b47afd08614139c1ce59554bfb275d038cd645a6b70a38d015cef9eeddd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4646f55df2ebd566f07d8273007737e757f9dbab102ca3da68d0118f4e408c9"
  end

  depends_on "pkgconf" => :build
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