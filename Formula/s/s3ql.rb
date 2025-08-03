class S3ql < Formula
  include Language::Python::Virtualenv

  desc "POSIX-compliant FUSE filesystem using object store as block storage"
  homepage "https://github.com/s3ql/s3ql"
  url "https://ghfast.top/https://github.com/s3ql/s3ql/releases/download/s3ql-5.3.0/s3ql-5.3.0.tar.gz"
  sha256 "f16e3aa218de86a7ec48002bbcb75c857f72f63d86e5e3c891b31a78c138d13c"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "2d116d2bed3369e6530af6411882b54809681562ce62ad7832ccec6abfa5ff3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6e371a9c17d44c7564e8776152225425762e47f9b6deba93c495829d82531bde"
  end

  depends_on "pkgconf" => :build

  depends_on "cryptography"
  depends_on "libffi"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "python@3.13"

  resource "apsw" do
    url "https://files.pythonhosted.org/packages/5b/c4/fcac432cb1aea5a1e7611e2ae927352232aec5c1546f10dece754279c4b9/apsw-3.49.2.0.tar.gz"
    sha256 "04280710d01f918b96ec9067111b57ee70780388bbf83fd33fc15c43e82afd51"
  end

  resource "async-generator" do
    url "https://files.pythonhosted.org/packages/ce/b6/6fa6b3b598a03cba5e80f829e0dadbb49d7645f523d209b2fb7ea0bbb02a/async_generator-1.10.tar.gz"
    sha256 "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "dugong" do
    url "https://files.pythonhosted.org/packages/10/90/2110a0201f34bd12ac75e67ddffb67b14f3de2732474e89cbb04123c4b16/dugong-3.8.2.tar.gz"
    sha256 "f46ab34d74207445f268e3d9537a72e648c2c81a74e40d5d0e32306d24ff81bb"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/cb/8e/8f45c9a32f73e786e954b8f9761c61422955d23c45d1e8c347f9b4b59e8e/google_auth-2.39.0.tar.gz"
    sha256 "73222d43cdc35a3aeacbfdcaf73142a97839f10de930550d89ebfe1d0a00cde7"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/fb/87/e10bf24f7bcffc1421b84d6f9c3377c30ec305d082cd737ddaa6d8f77f7c/google_auth_oauthlib-1.2.2.tar.gz"
    sha256 "11046fb8d3348b296302dd939ace8af0a724042e8029c1b872d87fabc9f41684"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "outcome" do
    url "https://files.pythonhosted.org/packages/98/df/77698abfac98571e65ffeb0c1fba8ffd692ab8458d617a0eed7d9a8d38f2/outcome-1.3.0.post0.tar.gz"
    sha256 "9dcf02e65f2971b80047b377468e72a268e15c0af3cf1238e6ff14f7f91143b8"
  end

  resource "pyfuse3" do
    url "https://files.pythonhosted.org/packages/67/1e/0f8f285a65e2e64f2f0c4accce4ee67d9ac66ee9684492a4327e48d68d87/pyfuse3-3.4.0.tar.gz"
    sha256 "793493f4d5e2b3bc10e13b3421d426a6e2e3365264c24376a50b8cbc69762d39"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/dc/3976b322de9d2e87ed0007cf04cc7553969b6c7b3f48a565d0333748fbcd/setuptools-80.3.1.tar.gz"
    sha256 "31e2c58dbb67c99c289f51c16d899afedae292b978f8051efaf6262d8212f927"
  end

  resource "trio" do
    url "https://files.pythonhosted.org/packages/01/c1/68d582b4d3a1c1f8118e18042464bb12a7c1b75d64d75111b297687041e3/trio-0.30.0.tar.gz"
    sha256 "0781c857c0c81f8f51e0089929a26b5bb63d57f927728a5586f7e36171f064df"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  # Fix incompatability with build isolation, since `setup.py` imports `s3ql`
  # Remove after https://github.com/s3ql/s3ql/pull/379
  patch :DATA

  def install
    # The inreplace changes the name of the (fsck|mkfs|mount|umount).s3ql
    # utilities to use underscore (_) as a separator, which is consistent
    # with other tools on macOS.
    # Final names: fsck_s3ql, mkfs_s3ql, mount_s3ql, umount_s3ql
    inreplace "pyproject.toml", /"(?:(mkfs|fsck|mount|umount)\.)s3ql" =/, '"\\1_s3ql" ='

    virtualenv_install_with_resources
  end

  test do
    assert_match "S3QL ", shell_output("#{bin}/mount_s3ql --version")

    # create a local filesystem, and run an fsck on it
    assert_match "Creating metadata", shell_output("#{bin}/mkfs_s3ql --plain local://#{testpath} 2>&1")
    assert_match "s3ql_params", shell_output("ls s3ql_params")
    system bin/"fsck_s3ql", "local://#{testpath}"
  end
end

__END__
diff --git a/setup.py b/setup.py
index 00f6e9b..2b0a101 100755
--- a/setup.py
+++ b/setup.py
@@ -34,7 +34,6 @@ if DEVELOPER_MODE:
 # Add S3QL sources
 sys.path.insert(0, os.path.join(basedir, 'src'))
 sys.path.insert(0, os.path.join(basedir, 'util'))
-import s3ql


 class pytest(TestCommand):
@@ -47,9 +46,6 @@ class pytest(TestCommand):


 def main():
-    with open(os.path.join(basedir, 'README.rst'), 'r') as fh:
-        long_desc = fh.read()
-
     compile_args = ['-Wall', '-Wextra', '-Wconversion', '-Wsign-compare']

     # Enable all fatal warnings only when compiling from Mercurial tip.
@@ -88,9 +84,7 @@ def main():
     setuptools.setup(
         name='s3ql',
         zip_safe=False,
-        version=s3ql.VERSION,
         description='a full-featured file system for online data storage',
-        long_description=long_desc,
         author='Nikolaus Rath',
         author_email='Nikolaus@rath.org',
         license='GPLv3',