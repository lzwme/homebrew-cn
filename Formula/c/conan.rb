class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for CC++"
  homepage "https:conan.io"
  url "https:files.pythonhosted.orgpackages45b4d77d0f0028c6dd230fca392f5e74b6b2c4424c82de67667b3ec9734e9423conan-2.12.2.tar.gz"
  sha256 "b09ff3d7fe8101e3ef55fd0785ae9ffbcd9237ac427da88c975e8c52908ed4f7"
  license "MIT"
  head "https:github.comconan-ioconan.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b2d002f7ae63f27ce7f78515cf45f470706a989d504c2d2816358678354452a0"
    sha256 cellar: :any,                 arm64_sonoma:  "8bdd2b6a01bcbbedeacd147ad48571b4cfee31410c3bcaa63033fe562d740315"
    sha256 cellar: :any,                 arm64_ventura: "6acdca56260998c0ddd0adca562ca6674a413ac35353b314e4700ce967bd0d8f"
    sha256 cellar: :any,                 sonoma:        "06203ffc0e121cad00e550e73402312a8e1b356d965160544b46aab8ff9e8cd8"
    sha256 cellar: :any,                 ventura:       "713bc6099c771a5a35520b6b0e334aad9dc30a8592bdad7010b22f23c4d69598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "403c5d0031d3f9733c80f7deba075525106e0c6ebe8c0da611cfde7b1935a9d7"
  end

  depends_on "pkgconf" => :build
  depends_on "cmake" => :test
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackages4b89eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "fasteners" do
    url "https:files.pythonhosted.orgpackages5fd4e834d929be54bfadb1f3e3b931c38e956aaa3b235a46a3c764c26c774902fasteners-0.19.tar.gz"
    sha256 "b4f37c3ac52d8a445af3a66bce57b33b5e90b97c696b7b984f530cf8f0ded09c"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesaf92b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccffjinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "patch-ng" do
    url "https:files.pythonhosted.orgpackageseec053a2f017ac5b5397a7064c2654b73c3334ac8461315707cbede6c12199ebpatch-ng-1.18.1.tar.gz"
    sha256 "52fd46ee46f6c8667692682c1fd7134edc65a2d2d084ebec1d295a6087fc0291"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagese4e86ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392furllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"conan", "profile", "detect"
    system bin"conan", "install", "--requires=zlib1.2.11",
                                   "--build=missing",
                                   "--lockfile-out=conan.lock"
    lockfile = JSON.parse(File.read("conan.lock", mode: "r"))
    refute_predicate lockfile["requires"].select { |req| req.start_with?("zlib1.2.11") }, :empty?
  end
end