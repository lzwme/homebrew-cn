class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.9.3.tar.gz"
  sha256 "50ac063a1457ac5adea11b7528d4d38d65ddbaf796f5d5b98cb5ec2ee2ece764"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "aac23838f7fc9b2fb01e30e3279dae90250ee6335fa7618c0166876c96e381eb"
    sha256 cellar: :any,                 arm64_sonoma:   "dedc103af54453786543aae2fcbc2f85a62a72504fd04de1b71b14b2ae87988d"
    sha256 cellar: :any,                 arm64_ventura:  "d6ea946bb873380962b492c79eb4148fb5334ec66322a531e2e72882f47f90b7"
    sha256 cellar: :any,                 arm64_monterey: "deea8a0d038d7321f6f10291509b5cf3b2c073afc70293e6dde362f0f0eddb68"
    sha256 cellar: :any,                 sonoma:         "487477ba28fd6d9fa31abce49075a8f40747740a2124474a35b296b8209e4da3"
    sha256 cellar: :any,                 ventura:        "c8d4accd5f7f0231a27e4e2c0456744ebae642f1aa97a1101d22c0b05de59536"
    sha256 cellar: :any,                 monterey:       "ae4ba094ec574678a1afeaafbb3aa6b0165ba2d6bfe77b7a254360f4f7fe68ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd1e1d144420eb6eb5150d8062249369f25526efee81b8365d6a64d7a2623b7"
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