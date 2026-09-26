class Humanbound < Formula
  include Language::Python::Virtualenv

  desc "Adversarial security testing engine, SDK, and CLI for AI agents"
  homepage "https://docs.humanbound.ai/"
  url "https://files.pythonhosted.org/packages/1a/9d/bc432fcd1d6dcbe2f41a964421724f24f36e3ce168b262fd6e47ff9c13f8/humanbound-2.10.0.tar.gz"
  sha256 "c3bec75dc75a917b1bb980bcb7e471ef90fd9e85bbb2cc18d7f0773e9e169d07"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8139b2b67e8e3442a82db583c62a44193983aee62bd6eb67289ab10a6df650c6"
    sha256 cellar: :any, arm64_tahoe:       "a32c218986e30afc9e019cc0abf30b03e1003e8f233086e8a68f24d96b75ee12"
    sha256 cellar: :any, arm64_sequoia:     "4866e084c4d85318b6def7b6b57f00616dbca4c50598802a80fc09932aa632c8"
    sha256 cellar: :any, arm64_linux:       "3ef58d003e52a812536806454043ab78a8cd7392e6cd629b04cec1487a9c3c1b"
    sha256 cellar: :any, x86_64_linux:      "f24f902959ea4d3181a0b64f8ed855a93a7fdcd5a01d2597e1bd61bdb79c1d93"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi pydantic]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "posthog" do
    url "https://files.pythonhosted.org/packages/bd/16/b5d1489bae5ef5bd20c85b5b95f2b44609926b4ddb6c86794213ce1a832b/posthog-7.60.0.tar.gz"
    sha256 "6c1ab0f0d31c83b47a3cf6b6829d4ee83f250a4f8844c4c24adae329982d3f36"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "json"

    assert_match version.to_s, shell_output("#{bin}/hb --version")

    # reading results with none present must fail cleanly
    output = shell_output("#{bin}/hb logs 2>&1", 1)
    assert_match "No local test results", output

    # starting a scan with no LLM provider configured must fail as expected
    (testpath/"bot.json").write <<~EOS
      {"streaming": null, "chat_completion": {"endpoint": "http://127.0.0.1:9/chat", "headers": {}, "payload": {"content": "$PROMPT"}}}
    EOS
    output = shell_output("#{bin}/hb test --local --endpoint bot.json 2>&1", 2)
    assert_match "No LLM provider configured", output

    # config round-trip: writes and reads back ~/.humanbound/config.yaml
    system bin/"hb", "config", "set", "provider", "ollama"
    assert_match "ollama", shell_output("#{bin}/hb config get provider")
    assert_path_exists testpath/".humanbound/config.yaml"

    # process a results file: read a run's logs.jsonl and export it as JSON
    (testpath/".humanbound/results/exp-test").mkpath
    (testpath/".humanbound/results/exp-test/logs.jsonl").write <<~EOS
      {"thread_id": "t1", "result": "fail", "fail_category": "llm01", "explanation": "test finding", "severity": 82}
    EOS
    system bin/"hb", "logs", "--format", "json", "-o", "out.json"
    logs = JSON.parse((testpath/"out.json").read)
    assert_equal 1, logs["total"]
    assert_equal "fail", logs["logs"].first["result"]
  end
end