class Tmt < Formula
  include Language::Python::Virtualenv

  desc "Test Management Tool"
  homepage "https://tmt.readthedocs.io"
  url "https://files.pythonhosted.org/packages/2f/d2/90dab987da30091efd1cfb3cd26b9c80ce6fae54cb7927cc309c72be4510/tmt-1.70.0.tar.gz"
  sha256 "ca74383d723a462f5a0b3468c65fcaaf1a50a20af043a6d54c85f741dbfb7897"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e27d31024862da68aeca74c8488cb680c9469b997f99e07cde25f4254f0b1052"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "444ed473d40f17873293413c2c75ddfbb73febf16e5c043208ce567862db19bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4ea683b7378e43373226f04c1cf070303c636036c4d0ed330feb062329f7f11"
    sha256 cellar: :any_skip_relocation, sonoma:        "99f8c6183dbcdc18cf60eb5ef25fa9610380f023ff77e095f0a8b836f689b79b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c34a1bfedfffa48bb4d41cffac843ec4b97b0421708099fcad0b7d11b2d7ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b3d7ccae08ceeadd3f8f71cb18fa29be81a259ccbeccc72c8b348f49d743349"
  end

  depends_on "beakerlib"
  depends_on "certifi" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: ["certifi", "pydantic", "rpds-py"]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/ae/b6/03bb70946330e88ffec97aefd3ea75ba575cb2e762061e0e62a213befee8/docutils-0.22.4.tar.gz"
    sha256 "4db53b1fde9abecbb74d91230d32ab626d94f6badfc575d6db9194a49df29968"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/94/b8/00651a0f559862f3bb7d6f7477b192afe3f583cc5e26403b44e59a55ab34/filelock-3.25.2.tar.gz"
    sha256 "b64ece2b38f4ca29dd3e810287aa8c48182bbecd1ae6e9ae126c9b35f1382694"
  end

  resource "flexcache" do
    url "https://files.pythonhosted.org/packages/55/b0/8a21e330561c65653d010ef112bf38f60890051d244ede197ddaa08e50c1/flexcache-0.3.tar.gz"
    sha256 "18743bd5a0621bfe2cf8d519e4c3bfdf57a269c15d1ced3fb4b64e0ff4600656"
  end

  resource "flexparser" do
    url "https://files.pythonhosted.org/packages/82/99/b4de7e39e8eaf8207ba1a8fa2241dd98b2ba72ae6e16960d8351736d8702/flexparser-0.4.tar.gz"
    sha256 "266d98905595be2ccc5da964fe0a2c3526fbbffdc45b65b3146d75db992ef6b2"
  end

  resource "fmf" do
    url "https://files.pythonhosted.org/packages/2c/fe/aed3f3befc18d725776c10fe621790002671d0c4d50a6287d71fa371cf90/fmf-1.7.0.tar.gz"
    sha256 "131b557786b912f99d49d8dcc84196e3c2f39c5ce5ffe8b78e48150afd380dc3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pint" do
    url "https://files.pythonhosted.org/packages/52/9d/b1379cdbd33a49d17d627bc24e2b63cca06a1c5343b38072d2889499e82e/pint-0.25.3.tar.gz"
    sha256 "f8f5df6cf65314d74da1ade1bf96f8e3e4d0c41b51577ac53c49e7d44ca5acee"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/34/64/8860370b167a9721e8956ae116825caff829224fbca0ca6e7bf8ddef8430/requests-2.33.0.tar.gz"
    sha256 "c7ebc5e8b0f21837386ad0e1c8fe8b829fa5f544d8df3b2253bff14ef29d7652"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"tmt", shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/tmt init --template mini")
    assert_match "Applying template 'mini'", output
    assert_match <<~YAML, (testpath/"plans/example.fmf").read
      summary: Basic smoke test
      execute:
          how: tmt
          script: tmt --help
    YAML

    assert_match version.to_s, pipe_output("#{bin}/tmt --version")
  end
end