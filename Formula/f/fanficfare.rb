class Fanficfare < Formula
  include Language::Python::Virtualenv

  desc "Download fanfiction and original stories as e-books"
  homepage "https://github.com/JimmXinu/FanFicFare"
  url "https://files.pythonhosted.org/packages/1b/84/339dfd4957851942ec2599bc476c23b5115ac72af83a3658feabb293cee6/fanficfare-4.59.0.tar.gz"
  sha256 "3bf35e9a2d6ca768913341136943ebb29350acf7f5bed5e7c5fb97343c415253"
  license "Apache-2.0"
  head "https://github.com/JimmXinu/FanFicFare.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7f6ac94396a9e1c6f39b53d40d9131a4f753e52f671eeed5c93eb0002542a0ef"
    sha256 cellar: :any, arm64_sequoia: "4aabe2d4cdb1308dde76ec341c15916af11129350eaabaf31355c5c78063f84a"
    sha256 cellar: :any, arm64_sonoma:  "ec0c6bce812077399af45ee10c2f8e955581ffd6ab03862042c9e5689b3e7fd1"
    sha256 cellar: :any, sonoma:        "6c081c22bed80062241c6ff13cca248c99ec7c885a1ad1435ad848a448436ee1"
    sha256 cellar: :any, arm64_linux:   "9a68550c7ad60e0abb6e46bc0f1e629ddaef8d5e7831ed863bf713a26a91aac3"
    sha256 cellar: :any, x86_64_linux:  "65c408703aaf3168f510a802314408b7226cdbd6f87f31012387e28714c9e9ef"
  end

  depends_on "pkgconf" => :build
  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"
  depends_on "sqlite" # APSW requires SQLite APIs not provided by macOS

  pypi_packages package_name:     "FanFicFare",
                exclude_packages: "certifi"

  resource "apsw" do
    url "https://files.pythonhosted.org/packages/9a/2a/ec1dfda955cda4b8d77b076553b87d428315bd3a17ea4286aa9dc40901fe/apsw-3.53.3.1.tar.gz"
    sha256 "7684d24e77dc9e3b301ee5374a8a9501ad8a85b821ce85391260a2448dd02323"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/19/b6/9df434a8eeba2e6628c465a1dfa31034228ef79b26f76f46278f4ef7e49d/chardet-7.4.3.tar.gz"
    sha256 "cc1d4eb92a4ec1c2df3b490836ffa46922e599d34ce0bb75cf41fd2bf6303d56"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "cloudscraper" do
    url "https://files.pythonhosted.org/packages/ac/25/6d0481860583f44953bd791de0b7c4f6d7ead7223f8a17e776247b34a5b4/cloudscraper-1.2.71.tar.gz"
    sha256 "429c6e8aa6916d5bad5c8a5eac50f3ea53c9ac22616f6cb21b18dcc71517d0d3"
  end

  resource "html2text" do
    url "https://files.pythonhosted.org/packages/f8/27/e158d86ba1e82967cc2f790b0cb02030d4a8bef58e0c79a8590e9678107f/html2text-2025.4.15.tar.gz"
    sha256 "948a645f8f0bc3abe7fd587019a2197a12436cd73d0d4908af95bfc8da337588"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"

    # Fix to build with Python 3.14.
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/b90dafff1bf342d34d539098013d0b9f318c7641.patch?full_index=1"
      sha256 "779f8bab52308792b7ac2f01c3cd61335587640f98812c88cb074dce9fe8162d"
      type :unofficial
      resolves "https://github.com/html5lib/html5lib-python/pull/589"
    end

    # Remove the build-time dependency on pkg_resources.
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/1dbc19cd6db72cb919885827bc4883423e0cb647.patch?full_index=1"
      sha256 "5951b823f353dd70806ad6e163ab8f46899496c1e8bb53970c99abe8d1df1a78"
      type :unofficial
      resolves "https://github.com/html5lib/html5lib-python/pull/592"
    end
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/3c/f8/5dc70102e4d337063452c82e1f0d95e39abfe67aa222ed8a5ddeb9df8de8/requests_file-3.0.1.tar.gz"
    sha256 "f14243d7796c588f3521bd423c5dea2ee4cc730e54a3cac9574d78aca1272576"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/d9/38/e12680bbe6b4f8f3d17adcaf38d26850aa756c85cf4a80e79fc12a018fe8/soupsieve-2.9.1.tar.gz"
    sha256 "c33e6605bbc71dd628b00c632d58ae607c22bade247e52553928f83bbb75b4ba"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    venv = virtualenv_install_with_resources without: "apsw"
    resource("apsw").stage do
      rm "setup.apsw"
      (buildpath/"setup.apsw").write <<~INI
        [build_ext]
        use_system_sqlite_config = True
      INI
      venv.pip_install Pathname.pwd
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fanficfare --version").strip
    assert_match "archiveofourown.org", shell_output("#{bin}/fanficfare --sites-list")
    system libexec/"bin/python", "-c", "import apsw"
  end
end