class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.177.0",
      revision: "02294680c0d7fb5843383c1aff654bf07729870d"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b054a1b540f78aaeed41e0015fcc11d985d70a242e8db1ac07475ef7acd6374"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eeb145dba75af196e1b2e9c4ec96dc6cc9c4ce4a1d871c2700972f7afe7e22b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e140fe9b6acac552a16aa8f941164e3bde7b63ad953fb13dae05d99c1050ed8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b4aea2fab1f56b87f4d01ddb0f194c8e5712356e057c63d4e69fb7ae586bf73"
    sha256 cellar: :any_skip_relocation, ventura:        "f4923c1adc9c98a39bc97517604d822372588bb13c9b1d7f5100c0365059a0ac"
    sha256 cellar: :any_skip_relocation, monterey:       "f8d531ae21ff806ff4b5ca7b73687425fd95cbb3894baa26607413bdea300b2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59661db35f5c80a05e8828ee565f62aac6432c156a75f7e2f5c3eed60070b827"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}eksctl create nodegroup 2>&1", 1)
  end
end