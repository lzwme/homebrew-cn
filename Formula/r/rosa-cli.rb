class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://ghfast.top/https://github.com/openshift/rosa/archive/refs/tags/v1.2.59.tar.gz"
  sha256 "18dbf016193169ad8fe4fac70dcb896fc5ed0b4d14bfcb8039c913dcd4da153e"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2443aafa830814a426abd29741650de71d6672d91031c6d77231d081c2220bb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d69fe4414dcca63ef715ef95b078211a67a555ac69ef29dba92fa203e31a244"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d90d2bd7ee180d69c0113ff5cf5690043373e98f4139ba06687fa6f9a42db33"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4cbcc7b3e79e8c59a9936ca2b8c122e7e19db63db204d92bdfe7cced3ac8145"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a1b08c06387aebe7ba47b4c4ef066ab6e4b03e35ea859278ed058afd41b6a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb82d2e997ad60bea00105c9cff7f73d4c0270a777766f4e90889cc6d90057f0"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end