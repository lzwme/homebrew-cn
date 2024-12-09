class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https:github.comanishathalyedotbot"
  url "https:files.pythonhosted.orgpackages2ad432af2df3fed3b63bceb7d6926be48bfefd3b5859148ac03cdd5ba3827699dotbot-1.20.2.tar.gz"
  sha256 "5bd001a532343fe0fdaca4c3a785419a4961a2edfccdd45cfea15aa837b8a97c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c9e41836c89680b56a0d0b043a8db76e7757e16be17e148847034f2c2a34cfd0"
    sha256 cellar: :any,                 arm64_sonoma:  "0299a9f7abed21f432d436f1cdff566cd3a3268bf0631056c70568bbd7a48c2e"
    sha256 cellar: :any,                 arm64_ventura: "e44eb4fc28e2df28b9a9d94802f2258d19e22ac5425b8f9d7e4bef4c8f611e89"
    sha256 cellar: :any,                 sonoma:        "84daafacf6bf396b92ab61cb267f5459f21be02d892a7671d98c1ec58720dbd7"
    sha256 cellar: :any,                 ventura:       "8e4dbba4cfda1be17ead0ae10c5acf00bf129db19691df610b391bb224113364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4d36c237e92775810efb21ceefdd274a6cb0a52fc0353e0571ee6ee8406da1d"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"install.conf.yaml").write <<~YAML
      - create:
        - brew
        - .brewtest
    YAML

    output = shell_output("#{bin}dotbot -c #{testpath}install.conf.yaml")
    assert_match "All tasks executed successfully", output
    assert_predicate testpath"brew", :exist?
    assert_predicate testpath".brewtest", :exist?
  end
end