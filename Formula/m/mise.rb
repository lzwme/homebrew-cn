class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.11.6.tar.gz"
  sha256 "78a57263dfe27fdee52b393b650bda3172c9c03163a7fd08a6fb66af0565fd80"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9c4e72d42f4270b8bed0a4634be106dc0b6ee41a1c3fec40597d795868558a6b"
    sha256 cellar: :any,                 arm64_sonoma:  "27fa6bd69112f97d5717c793d9b2615ed15fc957fe8fa7d9da38c9da879b5f2c"
    sha256 cellar: :any,                 arm64_ventura: "fceb7a280c4d57e495c3ba0ed0c4bedb7580822aafcb6eb11459b6e0c450a199"
    sha256 cellar: :any,                 sonoma:        "cb0520a62ab6fd52c5960ff9cf30b90b0d75e727e687491c7f9d624ba7f0f4cf"
    sha256 cellar: :any,                 ventura:       "1a393431e843ea6f2b10eec1a4a0d617ffc1c98c86b89e93606093f604200f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09125055e7e51c048c556ccbd83313e1f13abf3e20cf6624d571c624bac17a7a"
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