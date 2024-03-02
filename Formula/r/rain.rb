class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.8.0.tar.gz"
  sha256 "93539723e544db865f99e65afcdd4f53b4d7ec7e99a283cf652619145901c165"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e193e9afd9cd896296a63fa4d1b8bdf427f0601c02d8091caca76d5bba9a2308"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88492ec36d4753c20231290f2e783cd2ccf476307b9aac6204493de3a542a525"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43c05a015513cb7358cfef4b50e1535fcfbd8dd78b9c10dd98d7ac7829ba91cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e5d5f7477624a9648706721632e0d428601f7016734fa6d4caeae9d68596229"
    sha256 cellar: :any_skip_relocation, ventura:        "e3668cd2d32b4b0389a3a8de30f36403a54efb3bee8d845a54b03b3231157c26"
    sha256 cellar: :any_skip_relocation, monterey:       "3142e6949b0a0939748194f9a430e916b706a9c84a874cb4450d5953872c3f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e4731da517477bceeab76f873cec616f5f373c2c895964800d4514be1490b87"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmdrainmain.go"
    bash_completion.install "docsbash_completion.sh"
    zsh_completion.install "docszsh_completion.sh"
  end

  def caveats
    <<~EOS
      Deploying CloudFormation stacks with rain requires the AWS CLI to be installed.
      All other functionality works without the AWS CLI.
    EOS
  end

  test do
    (testpath"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}rain fmt -v test.template").strip
  end
end