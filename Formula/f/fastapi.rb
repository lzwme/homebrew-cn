class Fastapi < Formula
  include Language::Python::Virtualenv

  desc "CLI for FastAPI framework"
  homepage "https://fastapi.tiangolo.com/"
  url "https://files.pythonhosted.org/packages/a3/d4/96b417c2ec88df6be2fe90010e6e23c5323eeb2160c6cb0108f99707c130/fastapi-0.142.1.tar.gz"
  sha256 "761663e3e6939da45f997a6f68362abc0fa9d8606e76d504f15f806d2281581d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1120d8a9b65dffa7304ebb93399c270f25d80883a938d6129b62c869a9cd6b0b"
    sha256 cellar: :any, arm64_tahoe:       "ebf8d361156416c08854e8adbcedf34807510af0a0b56c8f077bb48826972cb1"
    sha256 cellar: :any, arm64_sequoia:     "b3d3e2db68eb26cce1c9d1ec2b83d012b96aee460d487751cc438675d7467ae9"
    sha256 cellar: :any, arm64_linux:       "f13a64d4c449b964037c6d4b3fea524d9757f4cb5cd8ef5c0c0d0027724c8823"
    sha256 cellar: :any, x86_64_linux:      "624714d15f6cbe3b690846300e11f8f1eadf54526cdd36ed934dc294651cf3f2"
  end

  depends_on "rust" => :build # for annotated-doc
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages package_name:     "fastapi[standard]",
                exclude_packages: ["certifi", "pydantic"]

  resource "agent-detector" do
    url "https://files.pythonhosted.org/packages/b3/92/2c3e2ad5ce9683876729034082af19cfb3fbafd1c298b22a0b0c10ecfdc5/agent_detector-2.0.0.tar.gz"
    sha256 "19c8ae185dbdca23c24abdcd8ac2cf58b8e84dc284c6f6db536656601f9ffc3f"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "detect-installer" do
    url "https://files.pythonhosted.org/packages/cd/eb/77b0cc7fc0235b0495b32410edebe14cf6757b826135a7f92bb0f5d843b9/detect_installer-0.2.1.tar.gz"
    sha256 "85f889d4d19c1caf5bef89ef389eb920cd8c6c2a868e1eeceec24527b93021e7"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/f5/22/900cb125c76b7aaa450ce02fd727f452243f2e91a61af068b40adba60ea9/email_validator-2.3.0.tar.gz"
    sha256 "9fc05c37f2f6cf439ff414f8fc46d917929974a82244c20eb10231ba60c54426"
  end

  resource "fastapi-cli" do
    url "https://files.pythonhosted.org/packages/33/eb/3b534c6f8e157f9ddbf2a153512307c886cad0b258739c200dd8ff8c4452/fastapi_cli-0.0.32.tar.gz"
    sha256 "38024d2345275e1b37ce8848727a580d84901b570e96b3256d9d36a9a5039424"
  end

  resource "fastapi-cloud-cli" do
    url "https://files.pythonhosted.org/packages/c0/8a/2857421c2218426e9f7635f9796e4e4bb41116b4b96d2fdf0cf8ed9ab5ae/fastapi_cloud_cli-0.26.0.tar.gz"
    sha256 "5fd64c26228c8ead803461e8b58ae64ffd586e960d97ab1fc848efac2d9539be"
  end

  resource "fastar" do
    url "https://files.pythonhosted.org/packages/cc/52/5bee9a672f418008d34c708d66e89e8f6fed8f0812f406a1c92fb5e393a8/fastar-0.12.0.tar.gz"
    sha256 "bba71522eae6a7627a5514ffdd4ac9645ef27d82e23931d79fd974bb49c3f2ad"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/8d/2b/6ce81972d5c8cab9705fddce3153be63222d9e12fd96f8baba5038a744dd/googleapis_common_protos-1.75.5.tar.gz"
    sha256 "c7a866fc34ed29a3b10af627a4b9b1dc2433313ca6e959f0ae4feb132047ed72"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/43/e5/d471fcb0e14523fe1c3f4ba58ca52480e7bd70ad7109a3846bc75892f7fb/httptools-0.8.0.tar.gz"
    sha256 "6b2a32f18d97e16e90827d7a819ffa8dbd8cc245fc4e1fa9d1095b54ef4bd999"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/1f/dc/e12c1fe1ed8a7b7149777127b1a0e12ce5bd5a81d97408bedc2128c260f5/opentelemetry_api-1.45.0.tar.gz"
    sha256 "711ede81773c8025c2c03dac0450bc89f3d30aea6eabcc815c570d4e35a963f7"
  end

  resource "opentelemetry-exporter-http-transport" do
    url "https://files.pythonhosted.org/packages/5e/31/cbedb10e08c3c932b80f58edf055a16bb48a500c23c617b758fb3ec18f08/opentelemetry_exporter_http_transport-0.66b0.tar.gz"
    sha256 "2c229b6593eaa22c86d9b8a15843dc23b406dbda00fb138339189aab07923b4e"
  end

  resource "opentelemetry-exporter-otlp-common" do
    url "https://files.pythonhosted.org/packages/68/09/01239cdfe8a414d46ed625b68b6da92666ffd16d93cc6dadf89404b4bd85/opentelemetry_exporter_otlp_common-0.66b0.tar.gz"
    sha256 "362268ec6aa705e183776ff938539df1e8ce45bc5509d242538b1d40c26fe6a6"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/e5/e0/ee3823dbdc10da15b5750becc37b61194dd7c55e3b56764ecbbe446f659a/opentelemetry_exporter_otlp_proto_common-1.45.0.tar.gz"
    sha256 "36495115a0c6a7aa946cfda9d59b6ed4e917b6ab0f75cdaf66bc1b176ec1be1f"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https://files.pythonhosted.org/packages/94/78/a503801c1c8f80b1d8aad0e14106a7c57f39344001652a78a683f9a9089e/opentelemetry_exporter_otlp_proto_http-1.45.0.tar.gz"
    sha256 "2f35496d96809f946f41b8805e6b93aec6c9b71b5fd759b75b6af4c084d992ae"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/72/28/67c38cfb7e2bdfdd0cde7dcdd0424aed0291fbd64aa4ea3e7e913734711a/opentelemetry_proto-1.45.0.tar.gz"
    sha256 "96ee414f24bc3f61ea8e17dc56b4348d4049d73db3eb17c6b3edf75b5b403300"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/ac/ed/ad32d76cc86ebce601105d01d13f8a08d6abc1852eaf69d79cf199bc1ee7/opentelemetry_sdk-1.45.0.tar.gz"
    sha256 "20caa5130505e386c67c3da1c76e446c842698ced54c76c6148679539aa97972"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/2e/21/910f085c0b83b80e45c341c7859baef37c877046b2c44c88d5ff2d5db948/opentelemetry_semantic_conventions-0.66b0.tar.gz"
    sha256 "97a77dce484c54861e7eeff7651fd8a806dd3c30e501dc316730215ec36890e6"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/89/5b8517baa72f84a67b8a307ba953c91057af618bf40bf676f3c03551f8f0/protobuf-7.36.2.tar.gz"
    sha256 "497d0463ff3316681da6c0b9e8d06cb465d61abce00b613ab42226175644d1bb"
  end

  resource "pydantic-extra-types" do
    url "https://files.pythonhosted.org/packages/66/71/dba38ee2651f84f7842206adbd2233d8bbdb59fb85e9fa14232486a8c471/pydantic_extra_types-2.11.1.tar.gz"
    sha256 "46792d2307383859e923d8fcefa82108b1a141f8a9c0198982b3832ab5ef1049"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/68/ca/31c57507b13119d7d3cfa1576dad2911a4861e3be07b579395f4e9d393f9/pydantic_settings-2.15.0.tar.gz"
    sha256 "694b793e84f766ba76a90ebdefc01d0a9a045dab0382bee70393da93712ad117"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/6a/53/ed9d74092561d4b01a2ef1349d52cdbc135e526c245f366b089cfca6de49/python_dotenv-1.2.3.tar.gz"
    sha256 "a20a594dabeaa385725aa239d5244871c143ecb356add8a20fcf23773a6c3a35"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5b/42/55c32bb9b12693c092ad250a0e82edb5b31ddeda6eb772de5f308b3804ad/python_multipart-0.0.32.tar.gz"
    sha256 "be54b7f3fa167bb83e4fcd936b887b708f4e57fe75911c02aebf53efaf8d938e"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-toolkit" do
    url "https://files.pythonhosted.org/packages/9f/1c/f134352beb393cc17e6241ecf0bf4dd41a6759e2e3971a69a6ad185b87a2/rich_toolkit-0.20.5.tar.gz"
    sha256 "0c9e1c414ffb0720be26285d472e263d1e704b71d31a7e13274b9996db4969e1"
  end

  resource "rignore" do
    url "https://files.pythonhosted.org/packages/ff/7e/aa0640d74f6b4bb68466f5899bd5ed1680480732344c31a408504e215801/rignore-0.8.1.tar.gz"
    sha256 "2b6cf58501e9ff1b6a71c3fd66c8a105311e1f23237626fd4c9c00606bb3d30f"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/67/93/9ef70bfb7346c778caf09b7cd10c17c33f601f2d17019fa1aedcda738b5f/sentry_sdk-2.71.0.tar.gz"
    sha256 "7beb27a22f06396f3a05510c3da6ea10e1c79e02e859993c27ce4ff074e296d6"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/7b/2b/3850dc6bf7ef71b088962eba31dafc6cffd2f96e577ebb0bb316df96da3e/starlette-1.7.0.tar.gz"
    sha256 "c79f74ea63cff761804fbbfb182f1e0b440c2d07b164d24700c5a1bab5d6ff5d"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/16/f7/57713ba479fd405eb76de31404b2c744c289e336b2d999511ebf51e496f7/typer-0.27.2.tar.gz"
    sha256 "269b7eb9d3c202ca84b4bc9618cb04ebb43d3d4d1e567e4c768607232c05f945"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/da/34/30e9280707135d2cfc589dfff3cb796bd07a3aeb1a3e415ba09dd89d7bb4/uvicorn-0.54.0.tar.gz"
    sha256 "a2e33cbfaa0306f8e6b0c13e0cb89d7d7a2da3e62b90c66e18c33d9807b28620"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/06/f0/18d39dbd1971d6d62c4629cc7fa67f74821b0dc1f5a77af43719de7936a7/uvloop-0.22.1.tar.gz"
    sha256 "6c84bae345b9147082b17371e3dd5d42775bddce91f885499017f4607fdaf39f"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/b3/68/e6aa0b77d217b31f8f486ec0cdfe5e00e6e38dc0be657e7d85819b9faf0a/watchfiles-1.3.0.tar.gz"
    sha256 "99aee4a07847c06820765fd7b1b49ceac4f3f711ccb7d104655a33231de1c207"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/18/72/fba934cb3dff7a85d811820efffcd141ddd52b5a2a01637f64551373ff4d/websockets-17.1.tar.gz"
    sha256 "acfea4c20bf54384883ea33b1240fc1db4f52e190823a4e2b334bc3e8bfca96a"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/fastapi"

    generate_completions_from_executable(bin/"fastapi", shell_parameter_format: :typer)
  end

  test do
    port = free_port

    (testpath/"main.py").write <<~PYTHON
      from fastapi import FastAPI

      app = FastAPI()

      @app.get("/")
      async def read_root():
          return {"Hello": "World"}
    PYTHON

    pid = spawn bin/"fastapi", "dev", "--port", port.to_s, "main.py"
    output = shell_output("curl --silent --retry 5 --retry-connrefused http://127.0.0.1:#{port}")
    assert_equal '{"Hello":"World"}', output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end