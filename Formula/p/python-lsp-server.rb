class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https:github.compython-lsppython-lsp-server"
  url "https:files.pythonhosted.orgpackages2b15b7e1577b9ca358e008b06910bf23cfa0a8be130ee9f319a262a3c610ee8dpython_lsp_server-1.12.0.tar.gz"
  sha256 "b6a336f128da03bd9bac1e61c3acca6e84242b8b31055a1ccf49d83df9dc053b"
  license "MIT"
  head "https:github.compython-lsppython-lsp-server.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e67359f4fcc666e205898c8aca11abc1191f5ba340896a2ea371578127d17e41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4846e9847455c2ee2f03ffd520eb809bc5a19c787ebeec2e77242e737e071d4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0edefd1a22511d131a636d8029d621eec4f056615ca780cbd29c758e4a9e848"
    sha256 cellar: :any_skip_relocation, sonoma:         "0cbc13238cbbc6944a8f67472b3495bcd61c1eb6294599e025e5cb0503c79172"
    sha256 cellar: :any_skip_relocation, ventura:        "785c86acdface32de100b2e628c38b6d5611e2364803ab755f44cf9e3589b6a5"
    sha256 cellar: :any_skip_relocation, monterey:       "9f029d367c10a869b81f765cbeb05c4a438c239929695d3193ddd93ca2582608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba1dc3ef199d15023124da38434a237c13e6b3abceca2af2259d2eca3d730db4"
  end

  depends_on "rust" => :build
  depends_on "python@3.12"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "black" do
    url "https:files.pythonhosted.orgpackages04b046fb0d4e00372f4a86a6f8efa3cb193c9f64863615e39010b1477e010578black-24.8.0.tar.gz"
    sha256 "2500945420b6784c38b9ee885af039f5e7471ef284ab03fa35ecdde4688cd83f"
  end

  resource "cattrs" do
    url "https:files.pythonhosted.orgpackages1e57c6ccd22658c4bcb3beb3f1c262e1f170cf136e913b122763d0ddd328d284cattrs-23.2.3.tar.gz"
    sha256 "a934090d95abaa9e911dac357e3a8699e0b4b14f8529bcc7d2b1ad9d51672b9f"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "docstring-to-markdown" do
    url "https:files.pythonhosted.orgpackages7aad6a66abd14676619bd56f6b924c96321a2e2d7d86558841d94a30023eec53docstring-to-markdown-0.15.tar.gz"
    sha256 "e146114d9c50c181b1d25505054a8d0f7a476837f0da2c19f07e06eaed52b73d"
  end

  resource "jedi" do
    url "https:files.pythonhosted.orgpackagesd69999b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0ajedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "lsprotocol" do
    url "https:files.pythonhosted.orgpackages9df66e80484ec078d0b50699ceb1833597b792a6c695f90c645fbaf54b947e6flsprotocol-2023.0.1.tar.gz"
    sha256 "cc5c15130d2403c18b734304339e51242d3018a05c4f7d0f198ad6e0cd21861d"
  end

  resource "mypy" do
    url "https:files.pythonhosted.orgpackages5c865d7cbc4974fd564550b80fbb8103c05501ea11aa7835edf3351d90095896mypy-1.11.2.tar.gz"
    sha256 "7f9993ad3e0ffdc95c2a14b66dee63729f021968bff8ad911867579c65d13a79"
  end

  resource "mypy-extensions" do
    url "https:files.pythonhosted.orgpackages98a41ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3fmypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "parso" do
    url "https:files.pythonhosted.orgpackages669468e2e17afaa9169cf6412ab0f28623903be73d1b32e208d9e8e541bb086dparso-0.8.4.tar.gz"
    sha256 "eb3a7b58240fb99099a345571deecc0f9540ea5f4dd2fe14c2a99d6b281ab92d"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesf5520763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages962d02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "pylsp-mypy" do
    url "https:files.pythonhosted.orgpackages769841e7fe44f2e9773bbf711ecc73c34a29b645ea6e454b36e723595d4ad4a4pylsp-mypy-0.6.8.tar.gz"
    sha256 "3f8307ca07d7e253e50e38c5fe31c371ceace0bc33d31c3429fa035d6d41bd5f"
  end

  resource "pylsp-rope" do
    url "https:files.pythonhosted.orgpackages5e4b2bbf498ebc1fa764f15c9155c0ed28900268ac22ddcb1d8cf219937bf151pylsp-rope-0.1.16.tar.gz"
    sha256 "d680b688c60a40257a8842ec808a6e0de1596a47a5300f22aecfdc69555020a7"
  end

  resource "python-lsp-black" do
    url "https:files.pythonhosted.orgpackagesc04806edc947f711fb076b564ee97bbecb5ae877816ccc0edf4347f57cd9d6b9python-lsp-black-2.0.0.tar.gz"
    sha256 "8286d2d310c566844b3c116b824ada6fccfa6ba228b1a09a0526b74c04e0805f"
  end

  resource "python-lsp-jsonrpc" do
    url "https:files.pythonhosted.orgpackages48b6fd92e2ea4635d88966bb42c20198df1a981340f07843b5e3c6694ba3557bpython-lsp-jsonrpc-1.1.2.tar.gz"
    sha256 "4688e453eef55cd952bff762c705cedefa12055c0aec17a06f595bcc002cc912"
  end

  resource "python-lsp-ruff" do
    url "https:files.pythonhosted.orgpackageseaec475febe2f9e799f44afa476a2c0e063368d4289a65b80457ed737f6d05c0python_lsp_ruff-2.2.2.tar.gz"
    sha256 "3f80bdb0b4a8ee24624596a1cff60b28cc37771773730f9bf7d946ddff9f0cac"
  end

  resource "pytoolconfig" do
    url "https:files.pythonhosted.orgpackages18dcabf70d2c2bcac20e8c71a7cdf6d44e4ddba4edf65acb179248d554d743dbpytoolconfig-1.3.1.tar.gz"
    sha256 "51e6bd1a6f108238ae6aab6a65e5eed5e75d456be1c2bf29b04e5c1e7d7adbae"
  end

  resource "rope" do
    url "https:files.pythonhosted.orgpackages1cc1875e0270ac39b764fcb16c2dfece14a42747dbd0f181ac3864bff3126af1rope-1.13.0.tar.gz"
    sha256 "51437d2decc8806cd5e9dd1fd9c1306a6d9075ecaf78d191af85fc1dfface880"
  end

  resource "ruff" do
    url "https:files.pythonhosted.orgpackages23f4279d044f66b79261fd37df76bf72b64471afab5d3b7906a01499c4451910ruff-0.6.2.tar.gz"
    sha256 "239ee6beb9e91feb8e0ec384204a763f36cb53fb895a1a364618c6abb076b3be"
  end

  resource "tomli" do
    url "https:files.pythonhosted.orgpackagesc03fd7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "ujson" do
    url "https:files.pythonhosted.orgpackagesf0003110fd566786bfa542adb7932d62035e0c0ef662a8ff6544b6643b3d6fd7ujson-5.10.0.tar.gz"
    sha256 "b3cd8f3c5d8c7738257f1018880444f7b7d9b66232c64649f562d7ba86ad4bc1"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackages0fb0e53bdd53d86447d211694f3cf66f163d077c5d68e6bcaa726bf64e88ae3awebsockets-13.0.tar.gz"
    sha256 "b7bf950234a482b7461afdb2ec99eee3548ec4d53f418c7990bb79c620476602"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"
    virtualenv_install_with_resources
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}pylsp -v 2>&1", input)
    assert_match(^Content-Length: \d+i, output)

    expected_plugins = %w[
      black
      pylsp_mypy
      pylsp_rope
      ruff
    ]
    expected_plugins.each do |plugin_name|
      assert_match("Loaded pylsp plugin #{plugin_name}", output)
    end
  end
end