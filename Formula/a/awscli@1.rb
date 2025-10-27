class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/11/82/ea8f6ec7cb4f445ce7dd0f42a95947937fd65734f06b7ed8482fe014193f/awscli-1.42.50.tar.gz"
  sha256 "3cce2944592f374364d6bf80cf60b8b13b93213b6f0799306a5fb7b0de862419"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b38c24950cea605a56ed689e66f8dca1aced519b3ff1bf7b886d06aa84325a1d"
    sha256 cellar: :any,                 arm64_sequoia: "4a95e4c3b2af5266c4f5f087f7c5fd1f6f24a8a0538938bfc9619d4ee8819994"
    sha256 cellar: :any,                 arm64_sonoma:  "44bd7267af50a0c2fb26fd8b5f36d4d9f14ce726b9bee5d9d0ec0d565e28cab3"
    sha256 cellar: :any,                 sonoma:        "495a4fdb4502e1d220256abf3455c9d96e0729c4cf8b7ba5c986f2c57ec57c00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06709f31a47ffaed78ec78f458f910d1d02306c5e4896df7b09fdc17c1302023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e5765a1b7b9391da5a1782147f03ba641c1127d3a74577cfa70c167a5a5ac4a"
  end

  keg_only :versioned_formula

  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/5b/66/21d9ac0d37e5c4e55171466351cfc77404d8d664ccc17d4add6dba1dee99/botocore-1.40.50.tar.gz"
    sha256 "1d3d5b5759c9cb30202cd5ad231ec8afb1abe5be0c088a1707195c2cbae0e742"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/6b/5c/330ea8d383eb2ce973df34d1239b3b21e91cd8c865d21ff82902d952f91f/docutils-0.19.tar.gz"
    sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  # Backport Python 3.14 support without CI changes. Remove next release (1.42.60)
  # https://github.com/aws/aws-cli/commit/44e446748504ed5a17df7c41c77c190bcba9fc5a
  patch :DATA

  def install
    virtualenv_install_with_resources
    pkgshare.install "awscli/examples"

    %w[aws.cmd aws_bash_completer aws_zsh_completer.sh].each { |f| rm(bin/f) }
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~ZSH
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    ZSH
  end

  def caveats
    <<~EOS
      The "examples" directory has been installed to:
        #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end

__END__
diff --git a/README.rst b/README.rst
index 51cdb7b9969a7092a77aaaa9c5eb0426391f68b5..063798c14912406788d37dd01ebee65be2f79719 100644
--- a/README.rst
+++ b/README.rst
@@ -31,6 +31,7 @@ The aws-cli package works on Python versions:
 -  3.11.x and greater
 -  3.12.x and greater
 -  3.13.x and greater
+-  3.14.x and greater
 
 Notices
 ~~~~~~~
diff --git a/awscli/arguments.py b/awscli/arguments.py
index 1c621b8657408273e75f6319aeb65811bde7f00e..686253ad0f6a5e9bf2c25ce926290755853408ca 100644
--- a/awscli/arguments.py
+++ b/awscli/arguments.py
@@ -449,7 +449,7 @@ def add_to_parser(self, parser):
         cli_name = self.cli_name
         parser.add_argument(
             cli_name,
-            help=self.documentation,
+            help=self.documentation.replace('%', '%%'),
             type=self.cli_type,
             required=self.required,
         )
diff --git a/setup.py b/setup.py
index bccbddab5134d481d7dea38af990f526d41af9ad..1daa35629cf75646d5aa35e085da212a4e15f2c8 100644
--- a/setup.py
+++ b/setup.py
@@ -63,6 +63,7 @@ def find_version(*file_paths):
         'Programming Language :: Python :: 3.11',
         'Programming Language :: Python :: 3.12',
         'Programming Language :: Python :: 3.13',
+        'Programming Language :: Python :: 3.14',
     ],
     project_urls={
         'Source': 'https://github.com/aws/aws-cli',