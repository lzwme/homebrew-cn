class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.1.3.tar.gz"
  sha256 "1ff5d6c644d724689f154b220a4c89805d5aa27a01208c043c0671d12c92af58"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "46e96b17afadbae50bd9e676ce37bf3d1abdfbbd7517310f3483b6c68fe6672e"
    sha256 cellar: :any,                 arm64_sonoma:  "c902d6dc84a936dc6c0f48c07ca719764271b2f7ea8a81e1207b0a5373de61a5"
    sha256 cellar: :any,                 arm64_ventura: "db21d8f2071b9071f3d48ef362326c06ed590ef6e6d5d39d7b37d71d13d0db91"
    sha256 cellar: :any,                 sonoma:        "c2ee2c960e0d7c151592b02cf2488a8bdf937a503e4bfc4b0e2e4b942a3ab756"
    sha256 cellar: :any,                 ventura:       "f3596e357884385265636df3e1a7b35f6a2bc2afd2e2de21c5aff46697c8356b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b214d1e8966bd97ced668ad6d155d90c5c6bea12f8d07b9524ea5b0752c382c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
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
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    FISH
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
    system bin"mise", "settings", "set", "experimental", "true"
    system bin"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}mise exec -- go version")

    [
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end