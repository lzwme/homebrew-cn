class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.7.3.tar.gz"
  sha256 "60192b6e9f43f403c8d1080abedcae79ef59f94703ac43f0c0fa72b9d334184c"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "94db09ee61f01a7e5b884b30fe1807b1e2b7aeef63b4dea095d05aaf11245f40"
    sha256 cellar: :any,                 arm64_ventura:  "47bcad4171282facabb5c8956e329d7a7105034780fdc9b73e4e53c0cfef1b94"
    sha256 cellar: :any,                 arm64_monterey: "913d6cc1484ec29c8f04c96375b073c42be790264429978f067d4f229a291752"
    sha256 cellar: :any,                 sonoma:         "422924b2f09d3dda93aca87b586805b89c0c86b95f29472316451c59596ab74f"
    sha256 cellar: :any,                 ventura:        "b4ab73756122b47959e5366622dfb880000ec6d9013da8aa9c4d1d0d5359d8cc"
    sha256 cellar: :any,                 monterey:       "82cb3f48fa176f21a0de4112063f81a65510db7ce54cc88519b9033693d44d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c609aacbe1c47eb218b4cbf136c3841ae4bcd1187e8c8d8395f7dc1bb4106b15"
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
    system "#{bin}mise", "install", "terraform@1.5.7"
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