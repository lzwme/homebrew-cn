class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https:github.comdanobiprr"
  url "https:github.comdanobiprrarchiverefstagsv0.19.0.tar.gz"
  sha256 "76d101fefe42456d0c18a64e6f57b9d3a84baaecaf1e3a5e94b93657a6773c11"
  license "GPL-2.0-only"
  revision 1
  head "https:github.comdanobiprr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "725334137a875b74691e3c7a7eeb8ede5590f73b5f2cd3163618432d74a38547"
    sha256 cellar: :any,                 arm64_sonoma:  "28416d452a963b23ef05bf27fb71bd78f0d7fcb7b7cad1c65a0c48f6d40cf450"
    sha256 cellar: :any,                 arm64_ventura: "71b7de882d22acf8d7e526ca0520944271048e2c1157bd50706f07c0fd98951b"
    sha256 cellar: :any,                 sonoma:        "c427a9782a010a451298dcc13a169771b31f181db32bf0e029160b2ad5afce34"
    sha256 cellar: :any,                 ventura:       "6b1678d5c38bf5e751cc592c725d64245936b33b7969b7b53f91a0bf50a5655a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de7157bd23986d61b335ef42cf1f8566763215930cd0fe00002a25cdfe52ed0b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  # support libgit2 1.8, upstream pr ref, https:github.comMitMarogit-interactive-rebase-toolpull948
  patch do
    url "https:github.comdanobiprrcommitc860f3d29c3607b10885e6526bea4cfd242815b5.patch?full_index=1"
    sha256 "208bbbdf4358f98c01b567146d0da2d1717caa53e4d2e5ea55ae29f5adaaaae2"
  end

  # completion and manpage support, upstream pr ref, https:github.comdanobiprrpull68
  patch do
    url "https:github.comdanobiprrcommit8ba7fdc2fcca86236311c65481af5b27a276a806.patch?full_index=1"
    sha256 "f74882907e25bc1af3e1556407c84e5477b3d7be3e51a2b40178ae17aaafaa0d"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # Ensure the declared `openssl@3` dependency will be picked up.
    # https:docs.rsopenssllatestopenssl#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Specify GEN_DIR for shell completions and manpage generation
    ENV["GEN_DIR"] = buildpath

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completionsprr.bash" => "prr"
    fish_completion.install "completionsprr.fish"
    zsh_completion.install "completions_prr"
    man1.install Dir["man*.1"]
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Failed to read config", shell_output("#{bin}prr get Homebrewhomebrew-core6 2>&1", 1)

    [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"prr", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end