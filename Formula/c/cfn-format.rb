class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.13.1.tar.gz"
  sha256 "97cabab71ed9aa1eb77203c8419856d52a0443b317014a698b152ee3b0385b88"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0837b16250d5c2c0a97cb22282e56b4aef1e612673df685cc5b6418d6f394c9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f86ad1d1181e26faf878200456f42fe15df81003a5ad3b0a6a5d071144c9b8ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad2d51d158e09d91e3fa9dd55ced6b7a497385de60e2c73678a6ff073988e4fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "7996a9e5a8ded25fa1e94cd52693f2398f4fff81e2853dbb2bc26b7132d50348"
    sha256 cellar: :any_skip_relocation, ventura:        "08e9796cf6f04d945c086355473c713a1d506c6f5efec8c42b8c3fa5b164d09a"
    sha256 cellar: :any_skip_relocation, monterey:       "32afed088968a5209c251f93d802274a21b9f2e6d387c27f84f8251e23a9e9fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59b3a976516f8bb9193986c072aee4d9ce80baa4793251f20a3b520a57f2e89d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmdcfn-formatmain.go"
  end

  test do
    (testpath"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}cfn-format -v test.template").strip
  end
end