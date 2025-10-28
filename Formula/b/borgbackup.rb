class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://www.borgbackup.org/"
  url "https://files.pythonhosted.org/packages/d3/8b/f24d8ab37b8d8cd85a55fa6cfaf98754bb7b6c7534c03ffe087506080a53/borgbackup-1.4.1.tar.gz"
  sha256 "b8fbf8f1c19d900b6b32a5a1dc131c5d8665a7c7eea409e9095209100b903839"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "fb7a0bf3c2cb3f40695c5c8b72e470780e462328185399941264fc2b9c6a53e7"
    sha256 cellar: :any,                 arm64_sequoia: "368609362d951f06cf4043bf4f267b8202a786a6f71fbf0ebef048e961343194"
    sha256 cellar: :any,                 arm64_sonoma:  "27ca1247a872be5b1d2f8d280f146a82ebbf992bd0d4c52d6f8633bdc7412f2b"
    sha256 cellar: :any,                 sonoma:        "3ac99574af8e25b3eb74d9d83681ab0e5ef327ad3fe2f1d585c35f8e71ab77c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ee52bb976ea6682b45b96c554b6bacd7de8a32847a2bada6ae4472e63ec3a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b333f70bf6b1bc9195017025fd5eeefde427be3ad0c819dfb59888247873b312"
  end

  depends_on "pkgconf" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "acl"
  end

  pypi_packages extra_packages: ["msgpack", "packaging"]

  # `msgpack` needs to be kept as v1.1.0

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
      system bin/"borg", "init", "-e", "none", "test-repo"
      system bin/"borg", "create", "--compression", "zstd", "test-repo::test-archive", "test.pdf"
    end
    mkdir testpath/"restore" do
      system bin/"borg", "extract", testpath/"test-repo::test-archive"
    end

    assert_path_exists testpath/"restore/test.pdf"
    assert_equal File.size(testpath/"restore/test.pdf"), File.size(testpath/"test.pdf")
  end
end