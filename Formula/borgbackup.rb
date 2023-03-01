class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/e6/a5/69a9ddce8ae769e1bf4d1f1e93459238f473bad770d4dddba108db91971c/borgbackup-1.2.3.tar.gz"
  sha256 "e32418f8633c96fa9681352a56eb63b98e294203472c114a5242709d36966785"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3a069c33502097749b1b8604357f69f665c0c5016ee6e1d4d370086ed768e9ab"
    sha256 cellar: :any,                 arm64_monterey: "b486d5311ef4f959c002dc04ec79f92b0c4206b469a3f6eef29eed7531d7b48c"
    sha256 cellar: :any,                 arm64_big_sur:  "bfc65d6a17d0f01bb8b6e251bd17831697bdeaa30f1c554ae633db46d1f93158"
    sha256 cellar: :any,                 ventura:        "4e4de3172980c24b8d75ff2db69ec02ec42f6336fef69b465f37e1999535df38"
    sha256 cellar: :any,                 monterey:       "b1f1ceb713e64dcbf9a3d2daf9ceb837e1207bbc6389ee5eb5a56c75a9d52fa5"
    sha256 cellar: :any,                 big_sur:        "8a729b30ee56fbe9c11897b7e3bbb53e12cc4e14767ccae7e5af05f0d83cc55d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "728fbbd77f97a94586b30379ddb48732aeedd2c49a3b496ef7d53ec6cec89dba"
  end

  depends_on "pkg-config" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "acl"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/22/44/0829b19ac243211d1d2bd759999aa92196c546518b0be91de9cacc98122a/msgpack-1.0.4.tar.gz"
    sha256 "f5d869c18f030202eb412f08b28d2afeea553d6613aee89e200d7aca7ef01f5f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/6b/f7/c240d7654ddd2d2f3f328d8468d4f1f876865f6b9038b146bec0a6737c65/packaging-22.0.tar.gz"
    sha256 "2198ec20bd4c017b8f9717e00f0c8714076fc2fd93816750ab48e2c41de2cfd3"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  def install
    ENV["BORG_LIBB2_PREFIX"] = Formula["libb2"].prefix
    ENV["BORG_LIBLZ4_PREFIX"] = Formula["lz4"].prefix
    ENV["BORG_LIBXXHASH_PREFIX"] = Formula["xxhash"].prefix
    ENV["BORG_LIBZSTD_PREFIX"] = Formula["zstd"].prefix
    ENV["BORG_OPENSSL_PREFIX"] = Formula["openssl@1.1"].prefix
    virtualenv_install_with_resources

    man1.install Dir["docs/man/*.1"]
    bash_completion.install "scripts/shell_completions/bash/borg"
    fish_completion.install "scripts/shell_completions/fish/borg.fish"
    zsh_completion.install "scripts/shell_completions/zsh/_borg"
  end

  test do
    # Create a repo and archive, then test extraction.
    cp test_fixtures("test.pdf"), testpath
    Dir.chdir(testpath) do
      system "#{bin}/borg", "init", "-e", "none", "test-repo"
      system "#{bin}/borg", "create", "--compression", "zstd", "test-repo::test-archive", "test.pdf"
    end
    mkdir testpath/"restore" do
      system "#{bin}/borg", "extract", testpath/"test-repo::test-archive"
    end
    assert_predicate testpath/"restore/test.pdf", :exist?
    assert_equal File.size(testpath/"restore/test.pdf"), File.size(testpath/"test.pdf")
  end
end