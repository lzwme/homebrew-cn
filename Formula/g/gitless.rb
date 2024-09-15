class Gitless < Formula
  include Language::Python::Virtualenv

  desc "Simplified version control system on top of git"
  homepage "https:gitless.com"
  url "https:files.pythonhosted.orgpackages9c2e457ae38c636c5947d603c84fea1cf51b7fcd0c8a5e4a9f2899b5b71534a0gitless-0.8.8.tar.gz"
  sha256 "590d9636d2ca743fdd972d9bf1f55027c1d7bc2ab1d5e877868807c3359b78ef"
  license "MIT"
  revision 16

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8bcbc5d09d836f357276ddc9f4083406f5cdb2970eec1b6bd87f5051837e309b"
    sha256 cellar: :any,                 arm64_sonoma:   "69850517e41bbb09758710e5a07d557d8b1ec37f14aea0c07c384aa5e7d9f6a5"
    sha256 cellar: :any,                 arm64_ventura:  "2a0595c10e3eff2323d62ff70d335ced3384f1ed87ef9b600e52afd49f16b215"
    sha256 cellar: :any,                 arm64_monterey: "d1c13b796904cc0b83713ed352b8a474956074ddcf4f203fc24928c145f2b5cc"
    sha256 cellar: :any,                 sonoma:         "ef319df5ff9b6eccd9bcb94aba23387879571dbdbae5eaf0a8d466bf52d10927"
    sha256 cellar: :any,                 ventura:        "8f3f8871d39d0ceac4ec5da03f5498ea5d483cb175b36cf8d624ab78e34c5c47"
    sha256 cellar: :any,                 monterey:       "9668d8dde6043374fc13d1b92d3c4b8b40aa27c94727b8d553b2eeda810f0228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd06e1a7154b24652d81b9f2f679c18bb8286851d862ef6bf06e8ddcec0735d6"
  end

  # https:github.comgitless-vcsgitlessissues248
  deprecate! date: "2024-07-17", because: :unmaintained

  depends_on "libgit2@1.7"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "args" do
    url "https:files.pythonhosted.orgpackagese51cb701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6bargs-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackages68ce95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91dcffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "clint" do
    url "https:files.pythonhosted.orgpackages3db441ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26dclint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages5e0b95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46depycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pygit2" do
    url "https:files.pythonhosted.orgpackagesf05e6e05213a9163bad15489beda5f958500881d45889b0df01d7b8964f031bfpygit2-1.14.1.tar.gz"
    sha256 "ec5958571b82a6351785ca645e5394c31ae45eec5384b2fa9c4e05dde3597ad6"
  end

  resource "sh" do
    url "https:files.pythonhosted.orgpackages7c71199d27d3e7e78bf448bcecae0105a1d5b29173ffd2bbadaa95a74c156770sh-1.12.14.tar.gz"
    sha256 "b52bf5833ed01c7b5c5fb73a7f71b3d98d48e9b9b8764236237bdc7ecae850fc"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  # Allow to be dependent on pygit2 1.9.0
  # Remove for next version
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "config", "--global", "user.email", '"test@example.com"'
    system "git", "config", "--global", "user.name", '"Test"'
    system bin"gl", "init"
    %w[haunted house].each { |f| touch testpathf }
    system bin"gl", "track", "haunted", "house"
    system bin"gl", "commit", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("git ls-files").strip
  end
end

__END__
diff --git arequirements.txt brequirements.txt
index 05f190a..6777cce 100644
--- arequirements.txt
+++ brequirements.txt
@@ -1,6 +1,6 @@
 # make sure to update setup.py

-pygit2==0.28.2  # requires libgit2 0.28
+pygit2==1.10.0  # requires libgit2 0.28
 clint==0.5.1
 sh==1.12.14;sys_platform!='win32'
 pbs==0.110;sys_platform=='win32'
diff --git asetup.py bsetup.py
index 68a3a87..388ca66 100755
--- asetup.py
+++ bsetup.py
@@ -68,7 +68,7 @@ setup(
     packages=['gitless', 'gitless.cli'],
     install_requires=[
       # make sure it matches requirements.txt
-      'pygit2==0.28.2', # requires libgit2 0.28
+      'pygit2==1.10.0', # requires libgit2 0.28
       'clint>=0.3.6',
       'sh>=1.11' if sys.platform != 'win32' else 'pbs>=0.11'
     ],