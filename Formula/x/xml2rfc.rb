class Xml2rfc < Formula
  include Language::Python::Virtualenv

  desc "Tool to convert XML RFC7749 to the original ASCII or the new HTML look-and-feel"
  homepage "https:xml2rfc.tools.ietf.org"
  url "https:files.pythonhosted.orgpackages195a4e4cbd0d669ff6bd368ba185bfbad3fb91ac4d500374398d2e245ddc5394xml2rfc-3.28.1.tar.gz"
  sha256 "76201b28f5b5d4c466dad74d972b3260013db0f462c76ebc633ea1c7fcd87194"
  license "BSD-3-Clause"
  head "https:github.comietf-toolsxml2rfc.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "edf0d2a76759f3a8a6c9459c2c05e4442b889e66d7fadbedf0d841dceb1b151e"
    sha256 cellar: :any,                 arm64_sonoma:  "d93dea3b5ef178c6b10fd8b5bc76faee5310be43e6dadc30134b0a4e4864125b"
    sha256 cellar: :any,                 arm64_ventura: "200d6b1f33b1936898fdcfcd92434171d140fe4987b6224d3bee32003a3105f9"
    sha256 cellar: :any,                 sonoma:        "fffae6f1d3be9df52221047be7a43ffda10b45c2f5b91e58222ea715dfa29356"
    sha256 cellar: :any,                 ventura:       "9f2dddcf991e8d75c0313d7874baa2c94fd80617790d7bbd6786d4a79c47a0f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4557209e3e4dbb9d0f6d4b7a4140f601495dc36f95523e2d4104f505013bebc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "476e0bec1830d5ab810bcef54231012ef1697eeb0968f2f644a991255fb36979"
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
    url "https:files.pythonhosted.orgpackages708a73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783eConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
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
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages9e8bdc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
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