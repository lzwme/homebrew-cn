class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
      tag:      "v0.6.13",
      revision: "6586a42388dd17a275dd1c1cfba50f3753fe717a"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d1151fc4bbfadcc63b763aece29cbe163da679856d6bb9eab3c90c169333534"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6aed51477bfa367d301897b92d82bb4fe07101124e2b327635b5f1b588ea0d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "263c3edcc04256e300ca372225d28cb88b4b0b55660989291b1bae4d9b62f823"
    sha256 cellar: :any_skip_relocation, sonoma:         "6871c91e6ba85b307885e378a0d2b4611929ea42dfa61cb57a3bd321d35d665b"
    sha256 cellar: :any_skip_relocation, ventura:        "c612fe358f3282d982aa326ade7428876a60a7c3c157758ba3fdc20a18a6bade"
    sha256 cellar: :any_skip_relocation, monterey:       "661f3bdc33376ffd8a227835bda4f645c854b9321563a0ba43017d64f156d3df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee2872e971339cf1d522c77862479c4a22601c20b25ab79ea1b3d3aa3039a138"
  end

  depends_on "go" => :build

  def install
    ldflags = ["-s", "-w",
               "-X sigs.k8s.io/aws-iam-authenticator/pkg.Version=#{version}",
               "-X sigs.k8s.io/aws-iam-authenticator/pkg.CommitID=#{Utils.git_head}",
               "-buildid=''"]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/aws-iam-authenticator"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/aws-iam-authenticator version")
    assert_match %Q("Version":"#{version}"), output

    system "#{bin}/aws-iam-authenticator", "init", "-i", "test"
    contents = Dir.entries(".")
    ["cert.pem", "key.pem", "aws-iam-authenticator.kubeconfig"].each do |created|
      assert_includes contents, created
    end
  end
end