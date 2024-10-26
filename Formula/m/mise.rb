class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.10.10.tar.gz"
  sha256 "d42ef1977f07176f823506b1378ea6a81f96584b9a4897427cee4d113fcd97a3"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "367dc1df2dfc066236f02f2958ea3ed675f8b1272952acc2b2abfb0f80ebba34"
    sha256 cellar: :any,                 arm64_sonoma:  "d9a9534ef6a8711d2338fa0beafa41c25ca0403a9a3c84bf2a88163503c800c7"
    sha256 cellar: :any,                 arm64_ventura: "15d38f854589228d0b1aec8e34b3407977fc679bd34e73360d4367e551a27ae3"
    sha256 cellar: :any,                 sonoma:        "e9816ea7de74632d0c229a6c189369722ec435fbe6ceeae4487bfe17cea0baf1"
    sha256 cellar: :any,                 ventura:       "a11ddfe3aac927ef383d23ffe0a12681af033c7aeead0022a6c5081402c4e233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a38ae4c386724e55cc21840f9166bcee85af298441744b154de00fdc492298a6"
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