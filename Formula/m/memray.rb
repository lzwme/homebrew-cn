class Memray < Formula
  include Language::Python::Virtualenv

  desc "Memory profiler for Python applications"
  homepage "https:bloomberg.github.iomemray"
  url "https:files.pythonhosted.orgpackages228261c74f5bde38a57b3087f8838bcdb4d91c11860f03f56e7f9fb829ef045fmemray-1.16.0.tar.gz"
  sha256 "57319f74333a58a9b3d5fba411b0bff3f2974a37e362a09a577e7c6fe1d29a36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8bc1a5e7dc4138e052ed3512195e32f0d1941f2e6f5b0ba0febe725d5afab316"
    sha256 cellar: :any,                 arm64_sonoma:  "18c7e6ca3bc4f67c5ae622373d156466844e35739f488a4a43765ded665b5ad4"
    sha256 cellar: :any,                 arm64_ventura: "ae8bbfe86a710917420b5ff15d316a07062291facb3893281ce49b276d74c6df"
    sha256 cellar: :any,                 sonoma:        "a3758666d6c8e4dcd3346131fd08030e85e9e3ffbe6b556e03cbf7a86b8ac1e7"
    sha256 cellar: :any,                 ventura:       "9c035ef9ea0cddcea807fdad91a7c435d9085bf5acbadd2b8d74b016a7d7f992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74d9bf6fa7fefe76fbb78945647f805bed51455a3c0961c22e8c8fd0c7d1010f"
  end

  depends_on "lz4"
  depends_on "python@3.13"

  on_linux do
    depends_on "pkgconf" => :build # for libdebuginfod
    depends_on "curl" # for libdebuginfod
    depends_on "elfutils" # for libdebuginfod
    depends_on "json-c" # for libdebuginfod
    depends_on "libunwind"

    # TODO: Consider creating a formula for (lib)debuginfod
    resource "elfutils" do
      url "https:sourceware.orgelfutilsftp0.192elfutils-0.192.tar.bz2"
      sha256 "616099beae24aba11f9b63d86ca6cc8d566d968b802391334c91df54eab416b4"
    end
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "linkify-it-py" do
    url "https:files.pythonhosted.orgpackages2aaebb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96alinkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdit-py-plugins" do
    url "https:files.pythonhosted.orgpackages1903a2ecab526543b152300717cf232bb4bb8605b6edb946c845016fa9c9c9fdmdit_py_plugins-0.4.2.tar.gz"
    sha256 "5f2cd1fdb606ddf152d37ec30e46101a60512bc0e5fa1a7002c36647b09e26b5"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackages41624af4689dd971ed4fb3215467624016d53550bff1df9ca02e7625eec07f8btextual-2.1.2.tar.gz"
    sha256 "aae3f9fde00c7440be00e3c3ac189e02d014f5298afdc32132f93480f9e09146"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "uc-micro-py" do
    url "https:files.pythonhosted.orgpackages917a146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  def install
    if OS.linux?
      without = "elfutils"
      libelf = Formula["elfutils"].opt_lib"libelf.so"
      resource("elfutils").stage do
        # https:github.combloombergmemrayblobmainpyproject.toml#L96-L104
        system ".configure", "--disable-debuginfod",
                              "--disable-nls",
                              "--disable-silent-rules",
                              "--enable-libdebuginfod",
                              *std_configure_args(prefix: libexec)
        system "make", "-C", "debuginfod", "install", "bin_PROGRAMS=", "libelf=#{libelf}"
        ENV.append "LDFLAGS", "-L#{libexec}lib -Wl,-rpath,#{libexec}lib"
      end
    end
    virtualenv_install_with_resources(without:)
  end

  test do
    system bin"memray", "run", "--output", "output.bin", "-c", "print()"
    assert_path_exists testpath"output.bin"

    assert_match version.to_s, shell_output("#{bin}memray --version")
  end
end