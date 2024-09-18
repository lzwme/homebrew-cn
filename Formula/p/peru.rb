class Peru < Formula
  include Language::Python::Virtualenv

  desc "Dependency retriever for version control and archives"
  homepage "https:github.combuildinspaceperu"
  url "https:files.pythonhosted.orgpackagesfe0eb78315545923029f18669d083826bc59a12006cd3bc430c8141f896310ccperu-1.3.2.tar.gz"
  sha256 "161d9fd85d8d37ef10eed1d8b38da126d7ba9554b585e40ed2964138fc3b2f00"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7d5b166a15d3b3573b1ee9cb6eabce4ea5a54a8b80ffe62e570192f5e70d8fa1"
    sha256 cellar: :any,                 arm64_sonoma:  "da1f6e577eb25d97cfdaf45976f06af8db223c4cdd3bac1a2520ce622fae9b06"
    sha256 cellar: :any,                 arm64_ventura: "e152295398950d395869ee00a7db79e5a29ba20a77510268227d4c162ee19014"
    sha256 cellar: :any,                 sonoma:        "9362cc653470a8be6146d0b5dabf68eedad97b9fcf6935e29caa8d71c382137a"
    sha256 cellar: :any,                 ventura:       "c17f689a900ef0467672b8b06e62e5bfddc02398e1f82e0e86eda337aaf65a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aac1b32a68c4df5e32054ae7abbd04e62b5498fb331b9076afd2303fe2bd5ab3"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "docopt" do
    url "https:files.pythonhosted.orgpackagesa2558f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    # Fix plugins (executed like an executable) looking for Python outside the virtualenv
    Dir["peruresourcesplugins***.py"].each do |f|
      inreplace f, "#! usrbinenv python3", "#!#{libexec}binpython3.12"
    end

    virtualenv_install_with_resources
  end

  test do
    (testpath"peru.yaml").write <<~EOS
      imports:
        peru: peru
      git module peru:
        url: https:github.combuildinspaceperu.git
    EOS
    system bin"peru", "sync"
    assert_predicate testpath".peru", :exist?
    assert_predicate testpath"peru", :exist?
  end
end