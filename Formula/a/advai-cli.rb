class AdvaiCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for managing skills and external CLIs"
  homepage "https://github.com/Advai-X/advai-cli"
  url "https://files.pythonhosted.org/packages/89/94/d8326155c88e6995f722158407574fccc77a813fb41768d3e69ca09858e2/advai_cli-1.0.9.tar.gz"
  sha256 "471a30bcfc9f3f1693eea612101b66e740282d3706f9ccafca9fe3af88543468"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f175083c56d4d999e7c72cecf4f316c761ac5166822de0569a9a655ff5b9b018"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38a57a4241f7cce12ab71a117a245fefa938999085b8f5130f4f4a7aeec06b0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d7b9eeebfdf0caea36fc2469a3d2a1aed1b0c7747e5dc20371006b8827e05f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "486f4e5206d020c69c85e9cc81b2a7e1e47fd7ef82a8cf78f4b27daa84228080"
    sha256 cellar: :any,                 arm64_linux:   "1859ff04bd34a8be7a0b47828bc85d8e6bce602c718722af8ce0b08dcb47bfa9"
    sha256 cellar: :any,                 x86_64_linux:  "35c177f7a91fb53d3fda0e7cddf72afaf448504431343ab7223bcaf40ce3058a"
  end

  depends_on "python@3.14"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/82/78/8ea7308cac6934de8c74a14f3d5f65d1c89287426688be79538d0e5c013d/aiohttp-3.14.1.tar.gz"
    sha256 "307f2cff90a764d329e77040603fa032db89c5c24fdad50c4c15334cba744035"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/79/12/1e8f37460ea0f7eb59c221fdaf0ed75e7ac43e97f8093b9c6f411df50a78/yarl-1.24.2.tar.gz"
    sha256 "9ac374123c6fd7abf64d1fec93962b0bd4ee2c19751755a762a72dd96c0378f8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"home").mkpath
    ENV["HOME"] = testpath/"home"

    assert_match version.to_s, shell_output("#{bin}/advai --version")
    assert_match "advai:", shell_output("#{bin}/advai info")
    assert_match "(no Skills installed)", shell_output("#{bin}/advai skill list")
    system bin/"advai", "kb", "create", "ci-kb"
    assert_path_exists testpath/"home"/".advai"/"kbs"/"ci-kb"
  end
end