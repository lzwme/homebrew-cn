class AwscliLocal < Formula
  include Language::Python::Virtualenv

  desc "Thin wrapper around the `aws` command-line interface for use with LocalStack"
  homepage "https://www.localstack.cloud/"
  url "https://files.pythonhosted.org/packages/7a/71/591a30da6819c96deca2286f145d5982e73b11e7f657e8cbfc5e003ca73f/awscli_local-0.22.2.tar.gz"
  sha256 "07c532c372753bf5f15426451dc91d6eec9de8779748049329a9a882bdac8a0b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b4773f188a0e6a375ac5620d71130616caf45994695e5065a9f9a96e053c5f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b4773f188a0e6a375ac5620d71130616caf45994695e5065a9f9a96e053c5f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b4773f188a0e6a375ac5620d71130616caf45994695e5065a9f9a96e053c5f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca4a146430c397d13afb721eba35fd11fe9351a23164612238c5126211d5d560"
    sha256 cellar: :any_skip_relocation, ventura:       "ca4a146430c397d13afb721eba35fd11fe9351a23164612238c5126211d5d560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b4773f188a0e6a375ac5620d71130616caf45994695e5065a9f9a96e053c5f8"
  end

  depends_on "awscli" => :test # awscli-local can work with any version of awscli
  depends_on "localstack"
  depends_on "python@3.13"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/45/dd/485d58afea6bf58638c0dbd7716d1505a80735cb94e9faececcccb1d1b31/boto3-1.40.4.tar.gz"
    sha256 "6eceffe4ae67c2cb077574289c0efe3ba60e8446646893a974fc3c2fa1130e7c"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2b/65/4f95659b9b2778d347bd9aacf7e1007dc2d89819ad9985da44a0d2ac1c63/botocore-1.40.4.tar.gz"
    sha256 "f1dacde69ec8b08f39bcdb62247bab4554938b5d7f8805ade78447da55c9df36"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/22/11/4f10b87d634edd616d8063dd0ed1193be747e524e28801f826d72828b98f/localstack_client-2.10.tar.gz"
    sha256 "732a07e23fffd6a581af2714bbe006ad6f884ac4f8ac955211a8a63321cdc409"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/6d/05/d52bf1e65044b4e5e27d4e63e8d1579dbdec54fce685908ae09bc3720030/s3transfer-0.13.1.tar.gz"
    sha256 "c3fdba22ba1bd367922f27ec8032d6a1cf5f10c934fb5d68cf60fd5a23d936cf"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/awslocal kinesis list-streams 2>&1", 255)
    assert_match "Could not connect to the endpoint URL", output
  end
end