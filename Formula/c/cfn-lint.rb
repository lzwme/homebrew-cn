class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/13/1a/9bd7e804cb01d42e0b3c78e45c14c4d42311a7e8970aeeae494c58a35d17/cfn_lint-1.59.0.tar.gz"
  sha256 "544e0bf49bcfe49da71aab8b770a50edaffeb4c317f35317a391353565e7187c"
  license "MIT-0"
  head "https://github.com/aws-cloudformation/cfn-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "32b380614109c5515582d2f48bd018cf196913f62b524ac5aa18083fa270cfbf"
    sha256 cellar: :any, arm64_tahoe:       "be1ae07fa2d918466ace17d15a08966f7aafda3824bb0f311bf345c7ea3162bd"
    sha256 cellar: :any, arm64_sequoia:     "577d034aac2679610cc713312f93d219d9a5bb4b6a5c0cb0ebda7e9e91b4e40b"
    sha256 cellar: :any, arm64_linux:       "a6e7a213dee4ce2780688fa547326fc540525d82a4597875f6a33a3479bc7ee4"
    sha256 cellar: :any, x86_64_linux:      "00de1d38d7a7173e080b37efc42f054500d2a0c9a602e533b5ed4aa108783a4b"
  end

  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: %w[pydantic rpds-py]

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/31/fd/359c6b0bf41d43eba15cafcd185fd82a11250f00606599ca8f296820fae2/jsonpatch-1.38.tar.gz"
    sha256 "debc3e7bdc3d446468d64987f51a0e7a9deea42987ff90a6d1005a489b471c19"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/54/04/e35b34f4e441473e62d82d6ed9a8f748d93d895f4c05d4e645aa0fde51d7/jsonpointer-3.6.tar.gz"
    sha256 "82e839a3ba3a9e2b54394fda8b3d276c2459d80408d06ef9a6fbc369d7544ffc"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/dc/76/3af777226b63a5e64a6b36b1ec5855c14e2b94a37096d4760e595fc43511/networkx-3.7.tar.gz"
    sha256 "fd77a511bd90f39f3d016351345b52cf5319b813bdca01de3f755d3cca62e96a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/fc/f2/af1da9d3ceed77bfcdce40427d49ba0be94e4fe84245e3bfef68c10e75b6/regex-2026.9.29.tar.gz"
    sha256 "8b5fcc4771732191b2b7d1dd68d8f0353f47f8d90b6150f6dce58bf1112442cb"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/83/d3/803453b36afefb7c2bb238361cd4ae6125a569b4db67cd9e79846ba2d68c/sympy-1.14.0.tar.gz"
    sha256 "d3d3fe8df1e5a0b42f0e7bdf50541697dbe7d23746e894990c030e2b05e72517"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cfn-lint --version")

    (testpath/"test.yml").write <<~YAML
      ---
      AWSTemplateFormatVersion: '2010-09-09'
      Resources:
        # Helps tests map resource types
        IamPipeline:
          Type: "AWS::CloudFormation::Stack"
          Properties:
            TemplateURL: !Sub 'https://s3.${AWS::Region}.amazonaws.com/bucket-dne-${AWS::Region}/${AWS::AccountId}/pipeline.yaml'
            Parameters:
              DeploymentName: iam-pipeline
              Deploy: 'auto'
    YAML
    system bin/"cfn-lint", "test.yml"
  end
end