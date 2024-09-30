class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.9.13.tar.gz"
  sha256 "b15514e4663e2e8074c8d76f0468963a83f7e81650cbca1f1b9484b3240aa559"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6c45134138d5c1d2f004d3779abbe05e07a97d439823cd00f772ccd42cffa019"
    sha256 cellar: :any,                 arm64_sonoma:  "0bfe5422e2557c74deee629ed7c557a1a00676b37da2d4a1cd6e28661ab04105"
    sha256 cellar: :any,                 arm64_ventura: "11336af3685a7e3886860de0e0d086ab5050fe77812748f3a316acf49535a691"
    sha256 cellar: :any,                 sonoma:        "4890cbc7d0d5029f2e33603fcb6ff5d3a24ef6c46eed1f05ee68bdc9514a0fdc"
    sha256 cellar: :any,                 ventura:       "c94bb328cc653375deb2816ffdeff6957a00800bdfbb61294176aa42bde1414e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb76324c165ace7fe7b2ec03c9a354b03395713259064e9c0ed4a43a1a494dc2"
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