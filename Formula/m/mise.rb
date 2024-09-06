class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.9.0.tar.gz"
  sha256 "a8b72176a85694d1314501c984ca91596c5629b1de9b984130f378beb6787887"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3b007b05c023b16c4ac82216b77a3290775dec5243c588d1378c0c3550b6fbf7"
    sha256 cellar: :any,                 arm64_ventura:  "95604046a9382d0f73526b3d9b3cf57f749b43af075a550625b5dd8af53ad943"
    sha256 cellar: :any,                 arm64_monterey: "28e96577e4758627c05979ef01030dfecf210c433010e487f4f4d52b6d16f523"
    sha256 cellar: :any,                 sonoma:         "74cb166b553d4900c78b3a5943886162fbac24648d936a9ac529e27f7a084363"
    sha256 cellar: :any,                 ventura:        "afeb16a10c0227223d39cdbfb37eac9806adc741b71caaa51bde956f4f3f1752"
    sha256 cellar: :any,                 monterey:       "df1574040f2d0882464f2d77b6844715549c0c57e97754564ecd174ba8115880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e32a2d3a42b0d0ea75fdbbdeee930ed089e2450061568fc36e807512221e0e9e"
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