class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper.git",
      tag:      "v0.7.0",
      revision: "9cabe9aafd12c95cd51e6fb0847aaa2eecd957d7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "888b13f73644f8fc95bd1f18e91c9e6c3af5b8f7d01b77b21d29bc97bf6ea0c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "888b13f73644f8fc95bd1f18e91c9e6c3af5b8f7d01b77b21d29bc97bf6ea0c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "888b13f73644f8fc95bd1f18e91c9e6c3af5b8f7d01b77b21d29bc97bf6ea0c1"
    sha256 cellar: :any_skip_relocation, ventura:        "0a21bfb02fc096d40ad44e9bff735a44c260189fad24f4ecf43e575c2a46833a"
    sha256 cellar: :any_skip_relocation, monterey:       "0a21bfb02fc096d40ad44e9bff735a44c260189fad24f4ecf43e575c2a46833a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a21bfb02fc096d40ad44e9bff735a44c260189fad24f4ecf43e575c2a46833a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3db9fc074cbf96f373a82e1a41e24fd56441fb3ff71d0f52d140b56f66d77177"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/local/docker-credential-ecr-login"
  end

  test do
    output = shell_output("#{bin}/docker-credential-ecr-login", 1)
    assert_match %r{^Usage: .*/docker-credential-ecr-login.*}, output
  end
end