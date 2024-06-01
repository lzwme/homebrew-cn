class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.5.28.tar.gz"
  sha256 "3599b14201ee1a723ce3934043249d38742ba51e7009234d65c0f8c3b3525e2f"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c490a97ecf54fe6514d3ee63b848e847bcac92abc5e6a8360c2ff00fd6c1752"
    sha256 cellar: :any,                 arm64_ventura:  "fcb4907e0790b5b5ada8f932307db5690ba252f19c58232a8f34638d93ca4393"
    sha256 cellar: :any,                 arm64_monterey: "57ce183e7c7ec5b36a713f415296a739d4c342a9a9b7173edc019416b48c31f5"
    sha256 cellar: :any,                 sonoma:         "35437e2aa434e13be7024a09d4e2a128322bd5e5fdb5473bac4be367691813cc"
    sha256 cellar: :any,                 ventura:        "3189be483edb7df0d1a0d705377eca7c0f80f29f33e6818094adb9239b2483a2"
    sha256 cellar: :any,                 monterey:       "ade9abbfe46e404222039ec08651461c9c7610d7557a6b29b395dc6ade3a811a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e023687b587f9525759a3c7b0826bf2e20e7d0ccb5197ee07d73ba4e1ab9767"
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