class ReconNg < Formula
  include Language::Python::Virtualenv

  desc "Web Reconnaissance Framework"
  homepage "https:github.comlanmaster53recon-ng"
  url "https:github.comlanmaster53recon-ngarchiverefstagsv5.1.2.tar.gz"
  sha256 "18d05030b994c9b37f624628251d3376d590f3d1eec155f67aca88fa5f3490cc"
  license "GPL-3.0-only"
  revision 1

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9283fa1d6b2535c9352e309cdc31f0243de1bf0ad47412647811dec88cb2e4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "506b6b1c98b3169377acb905497bccd5a41476ae72e29a0eef701721b4a5c9fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d639281e26312d57790e19e778bc13b673eea7fdcca9d4c6e4af81e834b3abf7"
    sha256 cellar: :any_skip_relocation, sonoma:         "f29f3c8595971d5d73c36960e84dac7559758e176f4b047fa919f6c492a1a889"
    sha256 cellar: :any_skip_relocation, ventura:        "cb6bfdde653e08be72e4c91a0fbaaf414b757d7c100038e9912c84dc7610a5b3"
    sha256 cellar: :any_skip_relocation, monterey:       "bf4db2e9c7237107c60c47a0655c1c9cb6725f413a6d3878dd621ee1d8987178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0685b46bc33139aea7a4258cae366b2cdb572e9f98d7686071b60bfdd1af4685"
  end

  depends_on "python-certifi"
  depends_on "python-lxml"
  depends_on "python-pytz"
  depends_on "python@3.11" # Python 3.12 issue: https:github.comlanmaster53recon-ngissues193
  depends_on "pyyaml"
  depends_on "six"

  # See the REQUIREMENTS file in the archive for the top level of dependencies.
  # Please check for changes that may have been made since the last update.

  resource "aniso8601" do
    url "https:files.pythonhosted.orgpackagescb72be3db445b03944bfbb2b02b82d00cb2a2bcf96275c4543f14bf60fa79e12aniso8601-9.0.1.tar.gz"
    sha256 "72e3117667eedf66951bb2d93f4296a56b94b078a8a95905a052611fb3f1b973"
  end

  resource "async-timeout" do
    url "https:files.pythonhosted.orgpackages546e9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43aasync-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages21313f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesa13444964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages598784326af34517fca8c58418d148f2403df25303e02736832403587318e9e8click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "dicttoxml" do
    url "https:files.pythonhosted.orgpackageseec93132427f9e64d572688e6a1cbe3d542d1a03f676b81fb600f3d1fd7d2ec5dicttoxml-1.7.16.tar.gz"
    sha256 "6f36ce644881db5cd8940bee9b7cb3f3f6b7b327ba8a67d83d3e2caa0538bf9d"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages99fbe7cd35bba24295ad41abfdff30f6b4c271fd6ac70d20132fa503c3e768e0dnspython-2.2.1.tar.gz"
    sha256 "0f7569a4a6ff151958b64304071d370daa3243d15941a7beedf0c9fe5105603e"
  end

  resource "flasgger" do
    url "https:files.pythonhosted.orgpackages4a6b0884acc545f131c82700834e8f48cf0fca7f9925163ce2f56cc57db49c23flasgger-0.9.5.tar.gz"
    sha256 "6ebea406b5beecd77e8da42550f380d4d05a6107bc90b69ce9e77aee7612e2d0"
  end

  resource "Flask" do
    url "https:files.pythonhosted.orgpackages69b653cfa30eed5aa7343daff36622843688ba8c6fe9829bb2b92e193ab1163fFlask-2.2.2.tar.gz"
    sha256 "642c450d19c4ad482f96729bd2a8f6d32554aa1e231f4f6b4e7e5264b16cca2b"
  end

  resource "Flask-RESTful" do
    url "https:files.pythonhosted.orgpackages5c504892719b13abd401f40a69359c3d859d0ea76bf78e66db058d6c06a95b01Flask-RESTful-0.3.9.tar.gz"
    sha256 "ccec650b835d48192138c85329ae03735e6ced58e9b2d9c2146d6c84c06fa53e"
  end

  resource "html5lib" do
    url "https:files.pythonhosted.orgpackagesacb6b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "itsdangerous" do
    url "https:files.pythonhosted.orgpackages7fa1d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "Jinja2" do
    url "https:files.pythonhosted.orgpackages7aff75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cceJinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages363dca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "MarkupSafe" do
    url "https:files.pythonhosted.orgpackages1d972288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "mechanize" do
    url "https:files.pythonhosted.orgpackagesb0026c3d393c72db98e8732ec85020a525494fdbb076c7511e3d331188a48154mechanize-0.4.8.tar.gz"
    sha256 "5e86ac0777357e006eb04cd28f7ed9f811d48dffa603d3891ac6d2b92280dc91"
  end

  resource "mistune" do
    url "https:files.pythonhosted.orgpackagescd9b0f98334812f548a5ee4399b76e33752a74fc7bb976f5efb34d962f03d585mistune-2.0.4.tar.gz"
    sha256 "9ee0a66053e2267aba772c71e06891fa8f1af6d4b01d5e84e267b4570d4d9808"
  end

  resource "pyrsistent" do
    url "https:files.pythonhosted.orgpackagesbf90445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "redis" do
    url "https:files.pythonhosted.orgpackages7a05671367bb466b3301bc4543fdad6ac107214ca327c8d97165b30246d87e88redis-4.4.0.tar.gz"
    sha256 "7b8c87d19c45d3f1271b124858d2a5c13160c4e74d4835e28273400fa34d5228"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagesa561a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "rq" do
    url "https:files.pythonhosted.orgpackagesf3f8f772ba09cfdbc7659039636dff2db4ea460dc5e84f4562e25cdc120762c3rq-1.11.1.tar.gz"
    sha256 "31c07e55255bdc05c804902d4e15779185603b04b9161b43c3e7bcac84b3343b"
  end

  resource "unicodecsv" do
    url "https:files.pythonhosted.orgpackages6fa4691ab63b17505a26096608cc309960b5a6bdf39e4ba1a793d5f9b1a53270unicodecsv-0.14.1.tar.gz"
    sha256 "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesc25132da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  resource "webencodings" do
    url "https:files.pythonhosted.orgpackages0b02ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "Werkzeug" do
    url "https:files.pythonhosted.orgpackagesf8c11c8e539f040acd80f844c69a5ef8e2fccdf8b442dabb969e497b55d544e1Werkzeug-2.2.2.tar.gz"
    sha256 "7ea2d48322cc7c0f8b3a215ed73eabd7b5d75d0b50e31ab006286ccff9e00b8f"
  end

  resource "XlsxWriter" do
    url "https:files.pythonhosted.orgpackagesf10ec798dbd2156a2b8e56ed543620ff6c1b0fa36e24c6fed33818afb465d6c5XlsxWriter-3.0.5.tar.gz"
    sha256 "fe2b1e2dec38ef8952e9a41a0290861a052e6771a9f43f5e3d56dc63b7112348"
  end

  def install
    libexec.install Dir["*"]
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources

    # Replace shebang with virtualenv python
    inreplace libexec"recon-ng", "#!usrbinenv python3", "#!#{libexec}binpython"

    bin.install_symlink libexec"recon-ng"
  end

  test do
    (testpath"resource").write <<~EOS
      options list
      exit
    EOS
    system "#{bin}recon-ng", "-r", testpath"resource"
  end
end