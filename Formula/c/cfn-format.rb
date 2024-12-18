class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https:github.comaws-cloudformationrain"
  url "https:github.comaws-cloudformationrainarchiverefstagsv1.20.1.tar.gz"
  sha256 "04cddedbe35074e66fa1683dacf9dc5cbb3913bcccaf9ba7a587936b2bce928b"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6e768f24eb23ea92dd76c895ad905db0434efd4943f529268859c5516362c07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6e768f24eb23ea92dd76c895ad905db0434efd4943f529268859c5516362c07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6e768f24eb23ea92dd76c895ad905db0434efd4943f529268859c5516362c07"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd2552e0cd48fc8e6626234f63ecd02ebb3f32637e50317d9624a6496654bf94"
    sha256 cellar: :any_skip_relocation, ventura:       "cd2552e0cd48fc8e6626234f63ecd02ebb3f32637e50317d9624a6496654bf94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03dcda6ce3d40535f88da80347554dc234357790c622d6fc0a15c5908a18d987"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcfn-format"
  end

  test do
    (testpath"test.template").write <<~YAML
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    YAML
    assert_equal "test.template: formatted OK", shell_output("#{bin}cfn-format -v test.template").strip
  end
end