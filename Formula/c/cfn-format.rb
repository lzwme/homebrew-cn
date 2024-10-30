class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.18.0.tar.gz"
  sha256 "b742cfbbb89740f4633fc9811dce9bac2d91612b9c9384d07439152f5af29daa"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bdd92024a241c49d05b59b16da79cfebba72552cb053d77be84ffceefffe4eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bdd92024a241c49d05b59b16da79cfebba72552cb053d77be84ffceefffe4eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bdd92024a241c49d05b59b16da79cfebba72552cb053d77be84ffceefffe4eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1854ede3911b9828fa0bb97674430348a6e443f4c8a6251d429e8e045c5e4747"
    sha256 cellar: :any_skip_relocation, ventura:       "1854ede3911b9828fa0bb97674430348a6e443f4c8a6251d429e8e045c5e4747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efd4de6aa6e0f0cc38587716636b6063b7f4dd6f05ca17672c23eb96bb8b04ca"
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