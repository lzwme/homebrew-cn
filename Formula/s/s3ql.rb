class S3ql < Formula
  include Language::Python::Virtualenv

  desc "POSIX-compliant FUSE filesystem using object store as block storage"
  homepage "https:github.coms3qls3ql"
  # TODO: Try to remove `cython` and corresponding build_cython in the next release.
  # Ref: https:github.coms3qls3qlissues335
  url "https:github.coms3qls3qlreleasesdownloads3ql-5.1.3s3ql-5.1.3.tar.gz"
  sha256 "9511f7c230f3b9ea16908a806649ed9bf90ee71ed6838ceb19db9cf4eb28ed5c"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5dba67563cfc911a83ace0d2edb967ef7f65c6edc9e798836aa2befe0117ae3c"
  end

  depends_on "cython" => :build
  depends_on "pkg-config" => :build
  depends_on "cffi"
  depends_on "cryptography"
  depends_on "libffi"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "six"

  resource "apsw" do
    url "https:files.pythonhosted.orgpackagese0e39987fe0294b4812efa460e7b4cc31690e7f095e195de2a2c1674fd821812apsw-3.43.2.0.tar.gz"
    sha256 "84f1916c2601631306979160019b217a9d29b876c18f9a36e5b8e1d15431ec66"
  end

  resource "async-generator" do
    url "https:files.pythonhosted.orgpackagesceb66fa6b3b598a03cba5e80f829e0dadbb49d7645f523d209b2fb7ea0bbb02aasync_generator-1.10.tar.gz"
    sha256 "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages979081f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbbattrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "dugong" do
    url "https:files.pythonhosted.orgpackages10902110a0201f34bd12ac75e67ddffb67b14f3de2732474e89cbb04123c4b16dugong-3.8.2.tar.gz"
    sha256 "f46ab34d74207445f268e3d9537a72e648c2c81a74e40d5d0e32306d24ff81bb"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages45710f19d6f51b6ea291fc8f179d152d675f49acf88cb44f743b37bf51ef2ec1google-auth-2.23.3.tar.gz"
    sha256 "6864247895eea5d13b9c57c9e03abb49cb94ce2dc7c58e91cba3248c7477c9e3"
  end

  resource "google-auth-oauthlib" do
    url "https:files.pythonhosted.orgpackages6a34c584323ea98fb596e71ade06c06d514de898c60498efc72311e18ebe2825google-auth-oauthlib-1.1.0.tar.gz"
    sha256 "83ea8c3b0881e453790baff4448e8a6112ac8778d1de9da0b68010b843937afb"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "outcome" do
    url "https:files.pythonhosted.orgpackages98df77698abfac98571e65ffeb0c1fba8ffd692ab8458d617a0eed7d9a8d38f2outcome-1.3.0.post0.tar.gz"
    sha256 "9dcf02e65f2971b80047b377468e72a268e15c0af3cf1238e6ff14f7f91143b8"
  end

  resource "pyfuse3" do
    url "https:files.pythonhosted.orgpackages7c67c045eca0938c75c609ba9200f474e3b8b13a5c813e119bf3ab2d1fa37ac4pyfuse3-3.3.0.tar.gz"
    sha256 "2b31fe412479f9620da2067dd739ed23f4cc37364224891938dedf7766e573bd"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4d5bdc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83dsetuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  resource "trio" do
    url "https:files.pythonhosted.orgpackages04b05ec370ef69832f3d6d79069af7097dcec0a8c68fa898822e49ad621c4af0trio-0.22.2.tar.gz"
    sha256 "3887cf18c8bcc894433420305468388dac76932e9668afa1c49aa3806b6accb3"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagescd50d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0acsniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "sortedcontainers" do
    url "https:files.pythonhosted.orgpackagese8c4ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    # The inreplace changes the name of the (fsck|mkfs|mount|umount).s3ql
    # utilities to use underscore (_) as a separator, which is consistent
    # with other tools on macOS.
    # Final names: fsck_s3ql, mkfs_s3ql, mount_s3ql, umount_s3ql
    inreplace "setup.py", '(?:(mkfs|fsck|mount|umount)\.)s3ql =, "'\\1_s3ql ="

    # Regenerate Cython files for Python 3.12 support. Try to remove in next release.
    ENV.prepend_path "PYTHONPATH", Formula["cython"].opt_libexecLanguage::Python.site_packages(python3)
    system libexec"binpython3", "setup.py", "build_cython"

    system libexec"binpython3", "setup.py", "build_ext", "--inplace"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "S3QL ", shell_output(bin"mount_s3ql --version")

    # create a local filesystem, and run an fsck on it
    assert_match "Creating metadata", shell_output(bin"mkfs_s3ql --plain local:#{testpath} 2>&1")
    assert_match "s3ql_params", shell_output("ls s3ql_params")
    system bin"fsck_s3ql", "local:#{testpath}"
  end
end