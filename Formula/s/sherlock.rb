class Sherlock < Formula
  include Language::Python::Virtualenv

  desc "Hunt down social media accounts by username"
  homepage "https://sherlockproject.xyz/"
  url "https://files.pythonhosted.org/packages/ff/d1/e4319259d1eb955aed24db5c91c110f46e72ad2d2ead70407f55c6b1dcc6/sherlock_project-0.16.2.tar.gz"
  sha256 "18cc9d571a84499eec43f3c96eaac1cb089e12ad0d0fc5016c828d38e035cc5a"
  license "MIT"
  revision 1
  head "https://github.com/sherlock-project/sherlock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b74c5b2a8b63d55fa7bdb6a89cf23b77aa2f6b8f2b11d41ae77439b4b8393aa2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6fec5cb545dc405ee029aa10432438cf1c1c8b750adaeb79143dd04db2737d75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be06eb18d8a25e9d5662b3abda3a94bf9d9a3a6cf32fcb2b91bb921c2f8326ca"
    sha256 cellar: :any,                 arm64_linux:       "b2c8c9be1345955ff19cbfc2729ab7ff056f35738182f2da05621f43745ad8ef"
    sha256 cellar: :any,                 x86_64_linux:      "9790e06763fe25d2ec68a0e9defbc033f4f04b33d85977fc292c4c0d3723cf60"
  end

  depends_on "cmake" => :build
  depends_on "certifi" => :no_linkage
  depends_on "numpy"
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: %w[certifi numpy]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/d3/38/af70d7ab1ae9d4da450eeec1fa3918940a5fafb9055e934af8d6eb0c2313/et_xmlfile-2.0.0.tar.gz"
    sha256 "dab3f4764309081ce75662649be815c4c9081e88f0837825f90fd28317d4da54"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/3d/f9/88d94a75de065ea32619465d2f77b29a0469500e99012523b91cc4141cd1/openpyxl-3.1.5.tar.gz"
    sha256 "cf0e3cf56142039133628b5acffe8ef0c12bc902d2aadd3e0fe5878dc08d1050"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/33/01/d40b85317f86cf08d853a4f495195c73815fdf205eef3993821720274518/pandas-2.3.3.tar.gz"
    sha256 "e05e1af93b977f7eafa636d043f9f94c7ee3ac81af99c13508215942e64c993b"

    # Workaround for meson 1.11+, deps type error
    patch do
      url "https://github.com/pandas-dev/pandas/commit/0e978b68ba68e0f3b1f8b9f6b5a38072948638f0.patch?full_index=1"
      sha256 "6d182353395464070bf683048dd3b7e79e11f66b4f38e053d2c49d1d060cbb99"
      type :backport
      resolves "https://github.com/pandas-dev/pandas/pull/63406"
    end
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/ed/fa23d28713004418bbf2407127f80f385bfb0bf4e677bef02c25c27b00ee/pytz-2026.4.tar.gz"
    sha256 "464303645bafafd72418898368b2429458f709cf1eb6a15372fbcc396b64da63"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-futures" do
    url "https://files.pythonhosted.org/packages/30/9f/efe743156e717c8abc499526fd8b4c613847214cf0a8ec8741189f5a84f2/requests_futures-1.1.0.tar.gz"
    sha256 "f839cf536e6638a6e0ca1cfd54ac761bf3bb2b5a7ecf9349557e53acc5244d36"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "stem" do
    url "https://files.pythonhosted.org/packages/94/c6/b2258155546f966744e78b9862f62bd2b8671b422bb9951a1330e4c8fd73/stem-1.8.2.tar.gz"
    sha256 "83fb19ffd4c9f82207c006051480389f80af221a7e4783000aedec4e384eb582"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/22/de/48c59722572767841493b26183a0d1cc411d54fd759c5607c4590b6563a6/tomli-2.4.1.tar.gz"
    sha256 "7c7e1a961a0b2f2472c1ac5b69affa0ae1132c39adcb67aba98568702b9cc23f"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/e4/31/3d74fa778a63b98b7374323befcc0be5ab3bd94afd4096a0124e7379152c/tzdata-2026.4.tar.gz"
    sha256 "f1b8bd365d8d210c55353f4d7f8d6d8561c0ba50d704b700d195a9424bba0d79"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sherlock --version")

    output = shell_output("#{bin}/sherlock --local --site GitHub homebrew")
    assert_match "GitHub: https://www.github.com/homebrew", output
    assert_match "Search completed with 1 results", output
  end
end