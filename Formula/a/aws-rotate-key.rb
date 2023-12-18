class AwsRotateKey < Formula
  desc "Easily rotate your AWS access key"
  homepage "https:github.comstefansundinaws-rotate-key"
  url "https:github.comstefansundinaws-rotate-keyarchiverefstagsv1.1.0.tar.gz"
  sha256 "0ecb4830dde426702629430889a8bcd4acddae9aab2d8f03ddab6514a3f966ef"
  license "MIT"
  head "https:github.comstefansundinaws-rotate-key.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5ab392e8975870ea050c63fbdcd74cb42c285c878e33a4a2b900b85bf2a8037"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efacf5c9c3a2359f9d034d3b8efe725d68b26d597f39c5eed8ee2ab131b7d338"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efacf5c9c3a2359f9d034d3b8efe725d68b26d597f39c5eed8ee2ab131b7d338"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efacf5c9c3a2359f9d034d3b8efe725d68b26d597f39c5eed8ee2ab131b7d338"
    sha256 cellar: :any_skip_relocation, sonoma:         "de399b54239a560a3e3b7f6fe6935b979d07d1e4c05dffbdcccd29a54de264de"
    sha256 cellar: :any_skip_relocation, ventura:        "442c81368bbd9de1d7ed039d571b871a1476eff719c3abb271013a24f11bd8d3"
    sha256 cellar: :any_skip_relocation, monterey:       "442c81368bbd9de1d7ed039d571b871a1476eff719c3abb271013a24f11bd8d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "442c81368bbd9de1d7ed039d571b871a1476eff719c3abb271013a24f11bd8d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e70bdac9444cdb273d4d92b0592f8e8fa387bda44387fe74a74b093b0bb1b92e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath"credentials").write <<~EOF
      [default]
      aws_access_key_id=AKIA123
      aws_secret_access_key=abc
    EOF
    output = shell_output("AWS_SHARED_CREDENTIALS_FILE=#{testpath}credentials #{bin}aws-rotate-key -y 2>&1", 1)
    assert_match "InvalidClientTokenId: The security token included in the request is invalid", output
  end
end