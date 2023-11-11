class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://ghproxy.com/https://github.com/openshift/rosa/archive/refs/tags/v1.2.30.tar.gz"
  sha256 "38eb5665d5cee28921f1db3a4e59304a3eb98f2eb34bd30b454bfc9493c1da8b"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e3b8c36b62839ea13a6adc8a08c1d82b26a2e774f388b7210c4375b8bf07319"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77095592415ae15bb8ed8b903d9eb7af20573b1470013850525cdf6642d5ce64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48e248f55040f4057ecb5f72e3262d4e0eddb4b493c3bad595e3382d4ff6116a"
    sha256 cellar: :any_skip_relocation, sonoma:         "652f5f71642f34d32563a81b29716206156e56d140aa25ff30de64544f5a293c"
    sha256 cellar: :any_skip_relocation, ventura:        "0d759d6f7e6c0ddc6e180cbfc76dbcdb89292bb3b845df058ea0388ca3bac0f5"
    sha256 cellar: :any_skip_relocation, monterey:       "e88580004b376f6df6916fe2cebab4c4a7f678559509bf979cb4bf651c02fd45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ee52a56787c53e3fd3714701e4ba77712a85707fdd1eb0b2308e55fb6ac4de5"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"
    generate_completions_from_executable(bin/"rosa", "completion", base_name: "rosa")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Failed to create AWS client: Failed to find credentials.",
                 shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end