class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/a6/19/f94be9fda92ea73cbf22b643a03a0b64559027ef5467765142d8242e712a/borgbackup-1.2.7.tar.gz"
  sha256 "f63f28a3383c041971cec87b061ca39a815b5fd445db24aa8172cac417d9411a"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "14a678b837c610113fdd4016c28c3a8fc0d68270e024be61ce0aba4071ca10ff"
    sha256 cellar: :any,                 arm64_ventura:  "fc334f0ae5286e6bfc94f82b4873f52f692f00670e9ed07c3be24b7b049e2488"
    sha256 cellar: :any,                 arm64_monterey: "97d661573da79192fd6d487d0a2437484eaa9e508c3c4c0ea34b1852592ffec6"
    sha256 cellar: :any,                 sonoma:         "87990713c58627a77691fa1339c104a068ed7142912c1898516fc4463a796a60"
    sha256 cellar: :any,                 ventura:        "d64701f5d40b28082c2837af7c7fe02fb0bd13cabf536890b576ba6b4f72c490"
    sha256 cellar: :any,                 monterey:       "bf19e7f2a71270ae581be1eebd1d1d2e50a5ea9dcfc44cddf5203bd90b71e75d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c7c2566edc313eadee52db6c19fec6c274d54b623be4a335f5f1ca3cc1e451d"
  end

  depends_on "pkg-config" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "python@3.12"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "acl"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  def install
    ENV["BORG_LIBB2_PREFIX"] = Formula["libb2"].prefix
    ENV["BORG_LIBLZ4_PREFIX"] = Formula["lz4"].prefix
    ENV["BORG_LIBXXHASH_PREFIX"] = Formula["xxhash"].prefix
    ENV["BORG_LIBZSTD_PREFIX"] = Formula["zstd"].prefix
    ENV["BORG_OPENSSL_PREFIX"] = Formula["openssl@3"].prefix

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