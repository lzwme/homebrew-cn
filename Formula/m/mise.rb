class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.8.10.tar.gz"
  sha256 "088629f5eaf1457b4a7b48d5bbbaab861adaa44faa20e222c724bfa07e75ff9b"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "591a7f9cc6c278768753f8d20cb2c506e8ab93a4e41d097f0d6c8a00faef5ab2"
    sha256 cellar: :any,                 arm64_ventura:  "e9851547295133bf6b5173b34e54d0907747f20792e93d93c5fb17053f307e5f"
    sha256 cellar: :any,                 arm64_monterey: "c0893d5d744ea8c1aea12a3d573c9e8e1f37e82bd67100a8d79d2e1d163d533a"
    sha256 cellar: :any,                 sonoma:         "47e710db6ee05eae0ab6b9075ce49620cb49611a5db848422fcccd7445b9ee49"
    sha256 cellar: :any,                 ventura:        "8ba7cc1e1809087001b1a14302b16d262a0d37981eac6d79126183326630e47b"
    sha256 cellar: :any,                 monterey:       "fbcb038f2455cf913b664c5a845e66ff7dd261a27b86aed015e8760daae484a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f356e112e078642e0e314c8ae36c336535a789b4609111007125f45669c67e4"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"

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