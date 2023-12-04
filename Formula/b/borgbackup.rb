class Borgbackup < Formula
  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/a6/19/f94be9fda92ea73cbf22b643a03a0b64559027ef5467765142d8242e712a/borgbackup-1.2.7.tar.gz"
  sha256 "f63f28a3383c041971cec87b061ca39a815b5fd445db24aa8172cac417d9411a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "bc31509030a17c5d4ef3d2eecad05b2fd404ed864dfa6f878db861b0dfde0f00"
    sha256 cellar: :any, arm64_ventura:  "33f99c655179e11e547f3c22b06699968bace5fa80073743dfba7d2f95699ae8"
    sha256 cellar: :any, arm64_monterey: "4fe506abe0b19de9178c48082b4a67edb2aea2f9a2433c3d322352861bf48c1a"
    sha256 cellar: :any, sonoma:         "7d0baacf487d75a952b5264d358184dc84178f65add94f16ac005104b33ee0a6"
    sha256 cellar: :any, ventura:        "19de0e2b52efdada354dac3301468d3c6c263a0f21e8dc0c2d2cc610bd668f53"
    sha256 cellar: :any, monterey:       "cac2b98a538f4f49eb46483fa7f573503d4a88250664855e44617314ea89cf91"
    sha256               x86_64_linux:   "5c8f52180ed2eae5ffd9aef6d2ffad9a1d7d9fb6100777d92f0a432b77d9cdce"
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