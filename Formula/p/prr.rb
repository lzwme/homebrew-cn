class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https:github.comdanobiprr"
  license "GPL-2.0-only"
  revision 2
  head "https:github.comdanobiprr.git", branch: "master"

  stable do
    url "https:github.comdanobiprrarchiverefstagsv0.19.0.tar.gz"
    sha256 "76d101fefe42456d0c18a64e6f57b9d3a84baaecaf1e3a5e94b93657a6773c11"

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
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "55088b52450bbe27b38177e4c0dbac2480defc15dc48e66aaf03c834178803b0"
    sha256 cellar: :any,                 arm64_sonoma:  "bd278e9e68140e02e6841496f7d84c6092f06390c7a525b4a5dbb8b5a1377fdc"
    sha256 cellar: :any,                 arm64_ventura: "c9e7b1a6479fd33c34d1be401fb6fc4145e36a642884bfeedb1574b323f4c1d6"
    sha256 cellar: :any,                 sonoma:        "a40a5696842f03b31a694ace93ce5775c42b747e42915a901031d487e2319580"
    sha256 cellar: :any,                 ventura:       "c79aa8de4e7ea6477ca584cca5261dcb7a955b3e845ea5321d1afa33c0344859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a878aed66f84e1e1be4885647859eaef4676cab25dae269aea0855203f10874"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"prr", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end