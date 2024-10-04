class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.10.0.tar.gz"
  sha256 "bf9d99fb8416f33e3828baf770b4d71d8a548ed75c11178e1e1763cfd619c64f"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c3862c77a873e69627aefe19f66837327a63d9cfa02cc7fb0f2e3ea5b7cc3051"
    sha256 cellar: :any,                 arm64_sonoma:  "73996f5656ca20b26b62b1fc6625def1981cc38f74efa1142c27ef732078bde5"
    sha256 cellar: :any,                 arm64_ventura: "8cf84d6113b966cad67b052a2713633ba4999004920e8b40fdebefc03466aaac"
    sha256 cellar: :any,                 sonoma:        "e8add73e2f173e46eda1eb7ce61d534ba3d15596be4116909a839cec32ca7c68"
    sha256 cellar: :any,                 ventura:       "b1bf3f1d973d19b8d87621e9a4df1c7925ae0c2adacf76f6ed70ed406a25efb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74bb5d0f9d7fd6b9c6982ebbf91520f17902095f8aa9424981d882936c3dc2f7"
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