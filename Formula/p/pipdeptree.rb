class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/f9/5f/26e1ee6608d88fc5d8cc7594466c952e02ce70ee33a6749225a2ad0b41ab/pipdeptree-4.2.2.tar.gz"
  sha256 "1aa054a0d1cd74a522a68d9368f9f67f87c2bbb865032b7ebd5e3bd7fd602ff5"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "700b7dc374ae0d177bd2f7b04ef21019cb84a525c55f1def225e2bbf62ab3215"
    sha256 cellar: :any, arm64_sequoia: "c8dbb2e4c5bc150351c5ec796c9baea3c6bdd008905cf90bab3628fbedac2603"
    sha256 cellar: :any, arm64_sonoma:  "e02893344492e0f6653e6fc30df84ca50e166143f7a0fc8418327aa94627298d"
    sha256 cellar: :any, arm64_linux:   "6f09aa7418c6ba56f03361eb8df1d9ac33825f5c03d9061ddd82c940bf5f9bd7"
    sha256 cellar: :any, x86_64_linux:  "ceeea4994cdb683f4cd6639064f9273c8b3043736e98af425f952c6a91787794"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "python@3.14"

  pypi_packages exclude_packages: "meson",
                extra_packages:   "meson-python"

  resource "build" do
    url "https://files.pythonhosted.org/packages/78/e0/df5e171f685f82f37b12e1f208064e24244911079d7b767447d1af7e0d70/build-1.5.0.tar.gz"
    sha256 "302c22c3ba2a0fd5f3911918651341ebb3896176cbdec15bd421f80b1afc7647"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/06/fe/b9f481cf0cc867958a21338baa900357b7b7d86cac9b025948049d77923c/installer-1.0.1.tar.gz"
    sha256 "052c7fc3721d54c696e2dea019be67539d7b144e924f559f54beb3121831c364"
  end

  resource "meson-python" do
    url "https://files.pythonhosted.org/packages/8b/f0/d794d7ed8a843a8a8947768f3b329d1e8601222dc95d930f4a5f9706cd6c/meson_python-0.20.0.tar.gz"
    sha256 "6d9726ae6cd37e22f210c74b364b30180a68c20442e97ff09f3c566a414af738"
  end

  resource "nab-index" do
    url "https://files.pythonhosted.org/packages/20/76/66e6209244e67b41df6df8a5b0a6b7f886a95f4f184413e46eab741a49cc/nab_index-0.0.14.tar.gz"
    sha256 "667e481c4aabba15b2e0c0686dc2133c29afb5cb8c904289e4f442698ed4e900"
  end

  resource "nab-project" do
    url "https://files.pythonhosted.org/packages/a5/b1/46dbadf0680a72a42bd30f16ac907d04dd16dce3952647ef016ccbfa7bf3/nab_project-0.0.14.tar.gz"
    sha256 "56d47e8f6d6474af58e60af504f22e325c41a71f0f1acd0b0aac1897a4e0a952"
  end

  resource "nab-provider" do
    url "https://files.pythonhosted.org/packages/43/9b/612b208cfc84cd2cba532765a982cd23acf5c437f05630d845d95ebf550c/nab_provider-0.0.14.tar.gz"
    sha256 "1bb3a52584fc03b7d1ec427c3b701047d45dd536f4d919305f5927b515c5fc74"
  end

  resource "nab-resolver" do
    url "https://files.pythonhosted.org/packages/78/8c/7a1ed494a94778c0b8a52c6c22d273a6e54916e1768f73f0502818d56e6a/nab_resolver-0.0.14.tar.gz"
    sha256 "52afb09bbae754733f2880cb6a6d51cdbbb278694b7d8ca27d6bea934ab9388b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/e7/82/28175b2414effca1cdac8dc99f76d660e7a4fb0ceefa4b4ab8f5f6742925/pyproject_hooks-1.2.0.tar.gz"
    sha256 "1e859bd5c40fae9448642dd871adf459e5e2084186e8d2c2a79a824c970da1f8"
  end

  resource "pyproject-metadata" do
    url "https://files.pythonhosted.org/packages/4f/76/1cae539918a7b1746d624c2f01560b793c22cd8c081157505bb9bbf0e34d/pyproject_metadata-0.12.1.tar.gz"
    sha256 "8809a4df6fe08279b39a8890669506ed3158e0617855ac9aff098fcbe772ae4c"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/22/de/48c59722572767841493b26183a0d1cc411d54fd759c5607c4590b6563a6/tomli-2.4.1.tar.gz"
    sha256 "7c7e1a961a0b2f2472c1ac5b69affa0ae1132c39adcb67aba98568702b9cc23f"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources.reject { |r| r.name == "meson-python" }
    # meson-python self-hosts via backend-path; without isolation it uses brew meson and ninja
    venv.pip_install resource("meson-python"), build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end