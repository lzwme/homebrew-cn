class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/92/b6/dfc0489b6baf5ef8d33c7aa15cf628962b4e09608b282092e39a9f75a28e/borgbackup-1.2.5.tar.gz"
  sha256 "72580779459ba72ea7e7d2e2a2ebd4f377c403236dd0ea148606036e4b631876"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fc920fe20aec725259a563d339391949b42a45271bcf01f9af48854a4da5d21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd28b9cebd3fa4b174c10f8a7b28420d7137b231c322548e619b51c709308806"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4cfe96dbd33dc4f0fc2a5ab17eb3a2f88eaaae89e78c83b9224925a178dddc9"
    sha256 cellar: :any_skip_relocation, ventura:        "2e5f6e6070030d9878d78d180d362c28b9e208186c3300c199656ec6ff280ec1"
    sha256 cellar: :any_skip_relocation, monterey:       "fa07b434b6e8c2b55e0dfa2d2c59fbfe37050afb89815dcc41429131af080e9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "086a020438883d323705e11cb5adba6cd377e31db838cb287e63d900c7940c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66649b67eeed42068e21f1b6597e55ea7f2e1baac399bc16659c3c4a1eef6838"
  end

  depends_on "pkg-config" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "python-packaging"
  depends_on "python@3.11"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "acl"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/dc/a1/eba11a0d4b764bc62966a565b470f8c6f38242723ba3057e9b5098678c30/msgpack-1.0.5.tar.gz"
    sha256 "c075544284eadc5cddc70f4757331d99dcbc16b2bbd4849d15f8aae4cf36d31c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
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