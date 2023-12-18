class JenkinsJobBuilder < Formula
  include Language::Python::Virtualenv

  desc "Configure Jenkins jobs with YAML files stored in Git"
  homepage "https:docs.openstack.orginfrajenkins-job-builder"
  url "https:files.pythonhosted.orgpackages74e8f559afa16434bd1280be101b24d2ea43cfbf5b4ad5a26cd4a5be86a60628jenkins-job-builder-5.0.4.tar.gz"
  sha256 "fb3aec7f28b823cbde9c518c2970cc52afbdf9fef2e88639f72d7f3890c4c46b"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e363e8ffba9fea51b3771dd251fb0b9c4aa26dcced533df25af64e2bb24d7ac3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "430964632a4f1619d660a1d41e28457f864ded999627dc31b94f946afcfbcbb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "221203f74961e006858f570f1224bd0c9d3228fb4b974d3380a56094013d1ee3"
    sha256 cellar: :any_skip_relocation, sonoma:         "67bd30b76036598c50dfd89d09b20ad85e55032f36934330b46d5571b3f68273"
    sha256 cellar: :any_skip_relocation, ventura:        "c28b8e05248307e24dc52efb33f36ef39ce1fde693c2b2faf42f42046659bb61"
    sha256 cellar: :any_skip_relocation, monterey:       "1e1833bb5532a4ecc918c0067ba53080c0e60674f227a50cad75145eeca8eeae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c4119aa8d7cb347d729b73998884826cfb46581865e93011eca7fc847b6cfe4"
  end

  depends_on "python-certifi"
  depends_on "python-markupsafe"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagescface89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "fasteners" do
    url "https:files.pythonhosted.orgpackages5fd4e834d929be54bfadb1f3e3b931c38e956aaa3b235a46a3c764c26c774902fasteners-0.19.tar.gz"
    sha256 "b4f37c3ac52d8a445af3a66bce57b33b5e90b97c696b7b984f530cf8f0ded09c"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackages7aff75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cceJinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "multi-key-dict" do
    url "https:files.pythonhosted.orgpackages6d972e9c47ca1bbde6f09cb18feb887d5102e8eacd82fbc397c77b221f27a2abmulti_key_dict-2.0.3.tar.gz"
    sha256 "deebdec17aa30a1c432cb3f437e81f8621e1c0542a0c0617a74f71e232e9939e"
  end

  resource "pbr" do
    url "https:files.pythonhosted.orgpackages02d8acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "python-jenkins" do
    url "https:files.pythonhosted.orgpackages83a9ad5efdb48044b7a4045f0de1262262da746e02d0bedd8cb8725144f8736cpython-jenkins-1.8.1.tar.gz"
    sha256 "ff5f1d92539d903f869b02eaf2b1314447e6d6d78f767edcfdd92967d532b9c6"

    # setuptools patch to fix the conflict with jenkins-job-builder
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patches08e835ejenkins-job-builderpython-jenkins-1.8.1-setuptools.patch"
      sha256 "f3319463368d8ed133ade64e6a4c4f01a28d45e6993a38012a26be55d8d3e765"
    end
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "stevedore" do
    url "https:files.pythonhosted.orgpackagesacd677387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8b00db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  # setuptools patch, upstream bug report, https:storyboard.openstack.org#!story2010842
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchesf4a0fb0jenkins-job-builder5.0.4-setuptools.patch"
    sha256 "35d06c1dbd44bd9cd36c188eaaddc846a4c64dbd5fc1fb1d3269e54de1f6e2b2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    command = "#{bin}jenkins-jobs test devstdin 2>&1"
    if OS.mac?
      output = pipe_output(command, "- job: { name: test-job }", 0)
      assert_match "Managed by Jenkins Job Builder", output
    else
      output = pipe_output(command, "- job: { name: test-job }", 1)
      assert_match "WARNING:jenkins_jobs.config:Config file", output
    end

    output = shell_output("#{bin}jenkins-jobs --version")
    assert_match "Jenkins Job Builder version: #{version}", output
  end
end