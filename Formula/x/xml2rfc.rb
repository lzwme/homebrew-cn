class Xml2rfc < Formula
  include Language::Python::Virtualenv

  desc "Tool to convert XML RFC7749 to the original ASCII or the new HTML look-and-feel"
  homepage "https:xml2rfc.tools.ietf.org"
  url "https:files.pythonhosted.orgpackages195a4e4cbd0d669ff6bd368ba185bfbad3fb91ac4d500374398d2e245ddc5394xml2rfc-3.28.1.tar.gz"
  sha256 "76201b28f5b5d4c466dad74d972b3260013db0f462c76ebc633ea1c7fcd87194"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comietf-toolsxml2rfc.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "72d9a1d05a2329cfabb2419c9b474b820f90f7d7e88385af98464524fe7feb50"
    sha256 cellar: :any,                 arm64_sonoma:  "e0f31f2356080c4d80383fbd277f94346689b5a7829b784798c5a855d275e596"
    sha256 cellar: :any,                 arm64_ventura: "0abca83a636ce8cd7f8ce4018110709b7cd93239bc7388128c1496c8477db371"
    sha256 cellar: :any,                 sonoma:        "9e521feba3843e67c9c28fe5ee760801701cbe9374c02c17c0fa8ded3b6c61c8"
    sha256 cellar: :any,                 ventura:       "66925bf7079f050de6396467c29c64d549bb8e67c6ce0f879cf5282bfb6d1a25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "463fd069e52db06294ce3ee246e2f2d0e02cc7af986faac0f770f3835ca94860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "121e579c8b4fb6f65661ef794a3f6fc6f7e1f7eb51bc75aa5289d585d13b2d06"
  end

  depends_on "libyaml"
  depends_on "python@3.13"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "libxslt"
  end

  resource "certifi" do
    url "https:files.pythonhosted.orgpackagese89ec05b3920a3b7d20d3d3310465f50348e5b3694f4f88c6daf736eef3024c4certifi-2025.4.26.tar.gz"
    sha256 "0a816057ea3cdefcef70270d2c515e4506bbc954f417fa5ade2021213bb8f0c6"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages854d6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5dconfigargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
  end

  resource "google-i18n-address" do
    url "https:files.pythonhosted.orgpackages3775c4dadb4845c8c930b94c8ff9d2dfa9855c0a005366af539fee8095e30765google_i18n_address-3.1.1-py2.py3-none-any.whl"
    sha256 "f66f4fd2b75d1cd371fc0a7678a1d656da4aa3b32932279e78dd6cae776fc23d"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "intervaltree" do
    url "https:files.pythonhosted.orgpackages50fb396d568039d21344639db96d940d40eb62befe704ef849b27949ded5c3bbintervaltree-3.1.0.tar.gz"
    sha256 "902b1b88936918f9b2a19e0e5eb7ccb430ae45cde4f39ea4b36932920d33952d"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages763d14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08flxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesfe8b3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pycountry" do
    url "https:files.pythonhosted.orgpackages7657c389fa68c50590881a75b7883eeb3dc15e9e73a0fdc001cdd45c13290c92pycountry-24.6.1.tar.gz"
    sha256 "b61b3faccea67f87d10c1f2b0fc0be714409e8fcdcc1315613174f6466c10221"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages185d3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fcasetuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "sortedcontainers" do
    url "https:files.pythonhosted.orgpackagese8c4ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}xml2rfc --version")

    (testpath"test.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <rfc category="info" docName="draft-sample-input-00"
           ipr="trust200902" submissionType="IETF">
        <?v3xml2rfc silence="The document date .*? is more than 3 days away from today's date" ?>
        <front>
          <title abbrev="Abbreviated Title">Put Your Internet Draft Title<title>
          <author fullname="John Doe" initials="J." role="editor" surname="Doe">
            <organization abbrev="Company">Company<organization>
            <address>
              <postal>
                <street><street>
                <city>Springfield<city>
                <region>IL<region>
                <country>US<country>
              <postal>
              <email>jdoe@example.com<email>
            <address>
          <author>
          <date month="December" year="2010" day="10">
          <abstract>
            <t>Insert an abstract: MANDATORY. This template is for creating an
              Internet-Draft.  With some out of scope characters
              in Chinese, by Xing Xing, 这里是中文译本
            <t>
          <abstract>
        <front>
        <middle>
          <section title="Some unicode strings">
            <t>Text body needs to deal with &#8216;funny&#8217; characters<t>
            <t>Pure out of scope 这里是中文译本<t>
            <t>Some re-mapped characters are ¢ or ©<t>
            <t>More re-mapped characters are ˜ and € and &#0094;<t>
          <section>
        <middle>
      <rfc>
    XML

    system bin"xml2rfc", "test.xml", "--text", "--out", "out.txt"

    output = (testpath"out.txt").read
    assert_match "Put Your Internet Draft Title", output
    assert_match "J. Doe", output
    assert_match "Text body needs to deal with", output
    assert_match "这里是中文译本", output
  end
end