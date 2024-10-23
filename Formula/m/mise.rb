class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.10.8.tar.gz"
  sha256 "77c4c6de558311564a79af13e2b79d51019dad669e6a1604edc834501cbf7758"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "525fb11867a8fe2f9048b60f53bdceb76e33e250b495e4ef6e0dfdff3f3285a9"
    sha256 cellar: :any,                 arm64_sonoma:  "2508453a0ab7ae167b5ce2339fcebc396d44e0d7293b27ec2c4d862450996b59"
    sha256 cellar: :any,                 arm64_ventura: "eeb0b4614f94b1b78838d3d35fd56d2f1c3a9234c65d31e721f99d042e3c6a08"
    sha256 cellar: :any,                 sonoma:        "58f45f716698ac70a966aed14ac72a4a470b8db6761b4059303566f6f2c56eda"
    sha256 cellar: :any,                 ventura:       "549fb7f6f572e6c72f7f11e2b2ed9ea444c2354150967cb6d7d07c25bbd68d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d772d06ef69b61bf0b1f4a5bfb3c6b7720e238842c958d9da2f3f478d97ee19"
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