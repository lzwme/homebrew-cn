class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.8.8.tar.gz"
  sha256 "41dea6aeb96b9d6f24eb8cd5f256743980022857c5ecd3be7a8c4dd627365da4"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "607e539cd803fd020664c2d2d055f99f287af419238c263473920c0b1f0c9cfa"
    sha256 cellar: :any,                 arm64_ventura:  "dbe9395729ba535835184b6aacfa3de5eefad40fb70f2003813b0faaa7fda791"
    sha256 cellar: :any,                 arm64_monterey: "85df0c5ee12df692a66191ee9a8a64e676686bb47d17b5b5e4baf18be73b3304"
    sha256 cellar: :any,                 sonoma:         "3a584465a950633bcde968b94059e536794327a7508493369fc4ff6bfe0fde94"
    sha256 cellar: :any,                 ventura:        "1770624f8f04296214e5e95a06ef1c9881d5de195587154914e6821cbe1a5209"
    sha256 cellar: :any,                 monterey:       "fcb1a4d559336d163904197f4b6f0afab387bd614272f1a2e31e7ea13ef794a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45387733420669b8ce8a01834915a7332ba10f20fe975bce902013e5840e9648"
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