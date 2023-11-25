class Borgbackup < Formula
  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/cd/a2/d4375923a8b858312e6f4593ac7f613d338394f3feb669f67d2a6269d2f9/borgbackup-1.2.6.tar.gz"
  sha256 "b7a6f8f086039eeec79070b914f3c651ed7f3612c965374af910d277c7a2139d"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_sonoma:   "8be4fcec56ffeca26519a466466eec38ee8c33a35a9a1be818cb7ab9d1636250"
    sha256 cellar: :any, arm64_ventura:  "63067c8d035186259e21c76219a943cf9ac8d362366a63df0723828902c49243"
    sha256 cellar: :any, arm64_monterey: "8907c2b978336fb248d02b4592d5d85725bc06287506d1b3360f61064a4d52eb"
    sha256 cellar: :any, sonoma:         "7f37935f0ba206a0b82d22ea67120b5820c5d45de1aa609d424a9f7bb4669373"
    sha256 cellar: :any, ventura:        "fc5b68a5e6b0684e3dfc7a799b0cd1d78381171ad28c92cff66c45fcaed016cb"
    sha256 cellar: :any, monterey:       "321f42d55498adaf73915b02f74c5b8201d4deb3af7e802b699ee8ec76a3cb8d"
    sha256               x86_64_linux:   "d428d84961538e3dfaf027d22a71157ca1568487b4d0b725ccd2fe04806f9622"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "python-msgpack"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python@3.12"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "acl"
  end

  def python3
    "python3.12"
  end

  # master build already support 1.0.7 without much change
  # new release requst issue, https://github.com/borgbackup/borg/issues/7948
  patch :DATA

  def install
    ENV["BORG_LIBB2_PREFIX"] = Formula["libb2"].prefix
    ENV["BORG_LIBLZ4_PREFIX"] = Formula["lz4"].prefix
    ENV["BORG_LIBXXHASH_PREFIX"] = Formula["xxhash"].prefix
    ENV["BORG_LIBZSTD_PREFIX"] = Formula["zstd"].prefix
    ENV["BORG_OPENSSL_PREFIX"] = Formula["openssl@3"].prefix

    system python3, "-m", "pip", "install", *std_pip_args, "."

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

__END__
diff --git a/src/borg/helpers/msgpack.py b/src/borg/helpers/msgpack.py
index 309c988..197d2de 100644
--- a/src/borg/helpers/msgpack.py
+++ b/src/borg/helpers/msgpack.py
@@ -182,7 +182,7 @@ def is_slow_msgpack():
 def is_supported_msgpack():
     # DO NOT CHANGE OR REMOVE! See also requirements and comments in setup.py.
     import msgpack
-    return (0, 5, 6) <= msgpack.version <= (1, 0, 5) and \
+    return (0, 5, 6) <= msgpack.version <= (1, 0, 7) and \
            msgpack.version not in [(1, 0, 1), ]  # < add bad releases here to deny list