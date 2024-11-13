class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.8.tar.gz"
  sha256 "2cb33bcbc9a852cbfaf03d1bf13c967200a319636665f302f62bf332f1506896"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "911d1676407071147067e84afc690e8d3b8bf12896d085a0a4d4b6ed333dcd1e"
    sha256 cellar: :any,                 arm64_sonoma:  "84a7fb794758c7d8d99b7e562f09672d4e5c638fd868afda09c48bb1cdbd8314"
    sha256 cellar: :any,                 arm64_ventura: "27d76f528334b6d75cedbfeea410730ae31cc238762b0f70788ea5fdbaa71e9f"
    sha256 cellar: :any,                 sonoma:        "42ac6a4dc215dad55f2c900d5a20d2bfa694eb67f758b855f5ba641c8424a2d9"
    sha256 cellar: :any,                 ventura:       "04c4558d3e4e65d46d91219bae483a9b83852dcdf70fac75babd86788bd6d4cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b746c9ce2317004a6ea9c7101aba81e5c14a0056245870faa0fdde0a3eb43ece"
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