class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/10/7e/d9395fa56b9f0f014e9e319daca03dd53133abefc2451b85f06ae4dc61dc/cfn_lint-1.58.0.tar.gz"
  sha256 "ba02cd7f7e06c8bc160936051a03ec931af52943fcc9cc72ad2748caa0f2a103"
  license "MIT-0"
  head "https://github.com/aws-cloudformation/cfn-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7919ed1484db87b6477c9af8299b8b1cb0f4d1514c3686b197222d8d9fea8e8b"
    sha256 cellar: :any, arm64_tahoe:       "fde1cc9c6ed62c8a7876f73db7172cf06dc3a5fb2f6a4d56288fb1bfbb0fff34"
    sha256 cellar: :any, arm64_sequoia:     "22bb7144a7f90ae7fb532e1318b061513e9eba17d05c4685b7584bb620c38f4f"
    sha256 cellar: :any, arm64_linux:       "2b2e671f9466f9ed322ecb4f913ac366c1892ad7d6a7dd2166e2a17034d973be"
    sha256 cellar: :any, x86_64_linux:      "e9b311e110480b151fbbd0be4125d68e91ee6b666e7af1ebfe9b14f0b63653b7"
  end

  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: %w[pydantic rpds-py]

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/8e/39/c534bb172e9318400d5631074b1eda6c78b7c918d0f04233b50caa8e2c10/jsonpatch-1.36.tar.gz"
    sha256 "7e110cb3c5a1c8768f7170bf8fb9887c4aa575fba74c95239e868b494bd9a522"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/52/77/9be5cce647fa4d7afa9047c0c1029bc73292c27430e64fc9d2393ccf6727/jsonpointer-3.4.tar.gz"
    sha256 "e57015ae65af3821c6a3976069860789cf326103f38b22b2178d41d021adad25"
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
    inreplace "pyproject.toml", 'requires-python = ">=3.10,<3.15"', 'requires-python = ">=3.10"'
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