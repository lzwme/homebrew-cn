class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.5.19.tar.gz"
  sha256 "4460d3f9d4c68a5dcc5dc8dbe24ed57a3d15cba717f547620eb2f9f65ed1dc5f"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b4393d4ead4a17af706dc5b94b3ea794e1d5dd1e4ddde18d253a939eae0420a7"
    sha256 cellar: :any,                 arm64_ventura:  "1faff2237dfcae05715c2086ec3b0be5ec1aabc510cb5b2b7ccc3a6aba683822"
    sha256 cellar: :any,                 arm64_monterey: "7b5ad60d4bf5a77afbb07bdcc31f9e79d87a4b20e17fcd19176cd8be0c2b5898"
    sha256 cellar: :any,                 sonoma:         "e3c93d5dc9ef976d7ba63cd0123497b07f17ed449a72d0b0e10e61efafa2911b"
    sha256 cellar: :any,                 ventura:        "37b93963b0cfe8de6451042753afea400cc9f1fa2ce2a34fb9f55d4af6af01f0"
    sha256 cellar: :any,                 monterey:       "4258ee48344f9415ea4a5b93f7257649bd41705742e13a19a15b2c5f87b33051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27d3519d8304e98c2be767d2e8811a9f307fcd14f5a0a6064469df43f4a51e60"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

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
    system "#{bin}mise", "install", "nodejs@22.1.0"
    assert_match "v22.1.0", shell_output("#{bin}mise exec nodejs@22.1.0 -- node -v")

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