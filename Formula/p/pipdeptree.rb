class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/92/1e/e1f9a3008b01eb6152cb88e72e2f9aad2ba15f48faf5ac90143c7d8cdd99/pipdeptree-4.2.0.tar.gz"
  sha256 "5477c117bca27c55f9384d74835b4d979741444e6af65b233fba2fc8786762cc"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3efe892919a07f81beb04232eb4286fb9d099b25c0f64a564da83c1b7fa04f0b"
    sha256 cellar: :any, arm64_sequoia: "c65176addfaa537c68916d51344b4dce64a0b7340276cd4ee64952f3af1c2e4d"
    sha256 cellar: :any, arm64_sonoma:  "91b7dcdfbc36b5381e65d3e99529d15fdd053513d84fc691418897969cec165c"
    sha256 cellar: :any, sonoma:        "e5fc8e1ff4a4694e99abd9c743bd863b125efa799b4965ad361f78e3163a860c"
    sha256 cellar: :any, arm64_linux:   "965a163321e5cfc80bb85adc3503cac07fce04aa840cd4008e5cb6190e832149"
    sha256 cellar: :any, x86_64_linux:  "25775d739e6dcfd6743151994e6fead52ffd45092c03ad40f21d6b3b47cc381e"
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
    url "https://files.pythonhosted.org/packages/31/df/2b02450bbf6ca1e180cb6a293d8cc977a873fcd313925c3e7b52dc22a192/nab_index-0.0.12.tar.gz"
    sha256 "21464bdabe3556db02791bdb11be5e097c5142e1c29c5a85ac61e4af1913e21c"
  end

  resource "nab-python" do
    url "https://files.pythonhosted.org/packages/c4/79/96124c20fff294e452cd56eefee05a70af12bde798727168e26eaacd3bf0/nab_python-0.0.12.tar.gz"
    sha256 "b24ed1c415e4fd3842c806b303db50ff11ff9ab0596404188995959b1e3887c2"
  end

  resource "nab-resolver" do
    url "https://files.pythonhosted.org/packages/57/fe/d9a8834cb4bb49cc0efae4ccc244520f1443e64ddf5839d717ac1bc4ccb1/nab_resolver-0.0.12.tar.gz"
    sha256 "ca2f32366b3a30dcb258b0e94724f550b17cc15862dde3aa48a1985cfb41e955"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
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