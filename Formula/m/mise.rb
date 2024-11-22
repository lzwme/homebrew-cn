class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.23.tar.gz"
  sha256 "886cb7bc5637c328cf0451428a17842a8840591f03dacda22d04def4faf6bdac"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "edc6f38f6c3a2353a064f02946085bbc179eba62698861a1bae52ed0cf76b066"
    sha256 cellar: :any,                 arm64_sonoma:  "92e1e83577846ec80482b127c39ff8ebf745b4bb9a80eb8d3e7451560d5b2055"
    sha256 cellar: :any,                 arm64_ventura: "4ee87d3ffb52deab7a2aac85e1153a1f2b273a46ab820833acd39b8d0b07ca1e"
    sha256 cellar: :any,                 sonoma:        "da88a15afc89fb282307eabcf2872bc3540864287afc0ddec93433a204caf6b8"
    sha256 cellar: :any,                 ventura:       "11b319738229f0cfc3fc2b901f48bbce2d2f9ac89f398e36168886b5ccbe8ca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efb0919aacaea114a19e6ac10125fe91f8bad4be2a6181c348b19536cf930456"
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