class Sigstore < Formula
  include Language::Python::Virtualenv

  desc "Codesigning tool for Python packages"
  homepage "https:github.comsigstoresigstore-python"
  url "https:files.pythonhosted.orgpackages10dcfb0306a86bd1bc79f99f2f53b2421a11c42d2bbd106f7ccf0acfb460b5dbsigstore-3.6.3.tar.gz"
  sha256 "9f957ef239b77695992b62823f79fc9554a589572dcc7bc0c1566a31b4bafc10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eddd5ef5f1ce37c44a16118af838d751f58c7cf3b565ad5ee125b53e08ead54f"
    sha256 cellar: :any,                 arm64_sonoma:  "1218badc58509222460715cfbff406ddf64c2baffad2fc131b040862d23d9c09"
    sha256 cellar: :any,                 arm64_ventura: "b265b1c14ab11c7897ca76cdccf327ddbaed757c3b4f2943f023deeb3effa157"
    sha256 cellar: :any,                 sonoma:        "f843248eb2665c18b2ba17e99c3019bce6713362a18e80829774810d14581ff6"
    sha256 cellar: :any,                 ventura:       "d5ee4cc25a39d63b89f0cf29e8a9a5eccb73c11d992402c11a1b82852a9fd06a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a8e1da1d05f274e8fe1219780c9422bbcb7932494145713ead3c67174e6512d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baf40b3276967b2b0b994d994d2669f577fbba4231a575dcf0557a89b48afd93"
  end

  depends_on "maturin" => :build # for rfc3161-client
  depends_on "pkgconf" => :build # for rfc3161-client
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "openssl@3" # for rfc3161-client
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "betterproto" do
    url "https:files.pythonhosted.orgpackages45434c44efd75f2ef48a16b458c2fe2cff7aa74bab8fcadf2653bb5110a87f97betterproto-2.0.0b6.tar.gz"
    sha256 "720ae92697000f6fcf049c69267d957f0871654c8b0d7458906607685daee784"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "email-validator" do
    url "https:files.pythonhosted.orgpackages48ce13508a1ec3f8bb981ae4ca79ea40384becc868bfae97fd1c942bb3a001b1email_validator-2.2.0.tar.gz"
    sha256 "cb690f344c617a714f22e66ae771445a1ceb46821152df8e165c5f9a364582b7"
  end

  resource "grpclib" do
    url "https:files.pythonhosted.orgpackages19750f0d3524b38b35e5cd07334b754aa9bd0570140ad982131b04ebfa3b0374grpclib-0.4.8.tar.gz"
    sha256 "d8823763780ef94fed8b2c562f7485cf0bbee15fc7d065a640673667f7719c9a"
  end

  resource "h2" do
    url "https:files.pythonhosted.orgpackages1b38d7f80fd13e6582fb8e0df8c9a653dcc02b03ca34f4d72f34869298c5baf8h2-4.2.0.tar.gz"
    sha256 "c8a52129695e88b1a0578d8d2cc6842bbd79128ac685463b887ee278126ad01f"
  end

  resource "hpack" do
    url "https:files.pythonhosted.orgpackages2c4871de9ed269fdae9c8057e5a4c0aa7402e8bb16f2c6e90b3aa53327b113f8hpack-4.1.0.tar.gz"
    sha256 "ec5eca154f7056aa06f196a557655c5b009b382873ac8d1e66e79e87535f1dca"
  end

  resource "hyperframe" do
    url "https:files.pythonhosted.orgpackages02e794f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "id" do
    url "https:files.pythonhosted.orgpackages2211102da08f88412d875fa2f1a9a469ff7ad4c874b0ca6fed0048fe385bdb3did-1.5.0.tar.gz"
    sha256 "292cb8a49eacbbdbce97244f47a97b4c62540169c976552e497fd57df0734c1d"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages912fa3470242707058fe856fe59241eee5635d79087100b7042a867368863a27multidict-6.4.4.tar.gz"
    sha256 "69ee9e6ba214b5245031b76233dd95408a0fd57fdb019ddcc1ead4790932a8e8"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesfe8b3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesbae901f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesf0868ce9040065e8f924d642c58e4a344e33163a07f6b57f836d0d734e0ad3fbpydantic-2.11.5.tar.gz"
    sha256 "7f853db3d0ce78ce8bbb148c401c2cdd6431b3473c0cdff2755c7690952a7b7a"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesad885f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackagese746bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages048ccd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rfc3161-client" do
    url "https:files.pythonhosted.orgpackages40cd84c91ba1a5f214ecfc2f63ba081436a971e8361a71a069a42f03f275168brfc3161_client-1.0.2.tar.gz"
    sha256 "37c78277d78aab02baf17393c30f66d1c2ab1a398d3540b0657792c0ceb81858"
  end

  resource "rfc8785" do
    url "https:files.pythonhosted.orgpackagesef2ffa1d2e740c490191b572d33dbca5daa180cb423c24396b856f5886371d8brfc8785-0.1.4.tar.gz"
    sha256 "e545841329fe0eee4f6a3b44e7034343100c12b4ec566dc06ca9735681deb4da"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa153830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "securesystemslib" do
    url "https:files.pythonhosted.orgpackagesf2d46f0ce9503269a94c307a51827c5c9fe0aa8f6b6aaaf9af36c9c611ba65f6securesystemslib-1.3.0.tar.gz"
    sha256 "5b53e5989289d97fa42ed7fde1b4bad80985f15dba8c774c043b395a90c908e5"
  end

  resource "sigstore-protobuf-specs" do
    url "https:files.pythonhosted.orgpackagesc031f73764f96787b53dd14641b2cc02dc7f4a0586de35c020ab1ff9bb12e833sigstore_protobuf_specs-0.3.2.tar.gz"
    sha256 "cae041b40502600b8a633f43c257695d0222a94efa1e5110a7ec7ada78c39d99"
  end

  resource "sigstore-rekor-types" do
    url "https:files.pythonhosted.orgpackagesb454102e772445c5e849b826fbdcd44eb9ad7b3d10fda17b08964658ec7027dcsigstore_rekor_types-0.0.18.tar.gz"
    sha256 "19aef25433218ebf9975a1e8b523cc84aaf3cd395ad39a30523b083ea7917ec5"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tuf" do
    url "https:files.pythonhosted.orgpackages25b5377a566dfa8286b2ca27ddbc792ab1645de0b6c65dd5bf03027b3bf8cc8ftuf-6.0.0.tar.gz"
    sha256 "9eed0f7888c5fff45dc62164ff243a05d47fb8a3208035eb268974287e0aee8d"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackagesf8b10c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sigstore -V")

    # NOTE: This resource and below do not needed to be kept up-to-date
    # with the latest sigstore-python release.
    resource "homebrew-test-artifact" do
      url "https:github.comsigstoresigstore-pythonreleasesdownloadv3.3.0sigstore-3.3.0.tar.gz", using: :nounzip
      sha256 "931e9913996ceace713d28e2431989414e711af30606f0b1e8bdc30fcbdd3fbe"
    end

    resource "homebrew-test-artifact.sigstore" do
      url "https:github.comsigstoresigstore-pythonreleasesdownloadv3.3.0sigstore-3.3.0.tar.gz.sigstore"
      sha256 "1cb946269f563b669183307b603f85169c7b1399835c66b8b4d28d913d26d5f7"
    end

    resource("homebrew-test-artifact").stage testpath
    resource("homebrew-test-artifact.sigstore").stage testpath

    cert_identity = "https:github.comsigstoresigstore-python.githubworkflowsrelease.yml@refstagsv3.3.0"

    output = shell_output("#{bin}sigstore verify github sigstore-3.3.0.tar.gz --cert-identity #{cert_identity} 2>&1")
    assert_match "OK: sigstore-3.3.0.tar.gz", output
  end
end