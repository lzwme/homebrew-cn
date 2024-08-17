class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.8.7.tar.gz"
  sha256 "f09cd3a09d58c318e02931cbfae263bb5aeda86cdb44fbd7ac3572c936dd49cc"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6048a002e46d9d96a056788f477cd13fd8089124856d40450585472eb13a85ea"
    sha256 cellar: :any,                 arm64_ventura:  "8ea1e93c85dd14a80455d9b60bb17ea8f2c9d7076bb6dd4f3ae7142994482831"
    sha256 cellar: :any,                 arm64_monterey: "cc4a0d5ccf323160df113e2d2718857f72b208f92d1db1749586ef888c3dca9a"
    sha256 cellar: :any,                 sonoma:         "9e9ed485040654af7700f1db4267a49e5e2ff30960fe01efbde3e6dcb7c61abd"
    sha256 cellar: :any,                 ventura:        "555192614542268be2ec7abc42e7f5954af092cbc9c8451b5dcae0345ed7f337"
    sha256 cellar: :any,                 monterey:       "994afd03ffb589c494a090cd316181fafdc3d1549488eef2a90e4b13c21840b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fe752a778891d5ca80b4f1a4497eddcad839980959c5c241816d4eca8599049"
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