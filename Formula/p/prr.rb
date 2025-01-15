class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https:github.comdanobiprr"
  url "https:github.comdanobiprrarchiverefstagsv0.20.0.tar.gz"
  sha256 "fa25e4690a6976af37738b417b01f1fa0df7448efd631239aadea0399a9e862a"
  license "GPL-2.0-only"
  head "https:github.comdanobiprr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9c765df97668492a4ad84de57bc6e16f81ca4fe743a05cafc06a6e08080ea206"
    sha256 cellar: :any,                 arm64_sonoma:  "f3933eff7e8c317e2bac08b82a227160a9759f17204427a40691e7d0dc8deb67"
    sha256 cellar: :any,                 arm64_ventura: "1456631c5e2b4bc0484b46efc28e6dc1f694bd23958497542962ac0b45c2179f"
    sha256 cellar: :any,                 sonoma:        "20d2cd9a366af2e2de5c4106b57ca1c1a231fc5b8571fc292581eadb2a6a9088"
    sha256 cellar: :any,                 ventura:       "5abd0b3b9851360119bf5df5a8693cc70b5de849128ec9073c3f914c337fff1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1667b82bf92db3853a68148bd85723defa29bffbbc7866bc661667910d979249"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
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
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"prr", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end