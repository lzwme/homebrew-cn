class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://ghproxy.com/https://github.com/openshift/rosa/archive/refs/tags/v1.2.29.tar.gz"
  sha256 "da7ecc8af697ebb385a5f120de7cfecd465e8a56a055d88322e961dbebb207cc"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c03a5416ea620db0d12dc52eece844a74b0449fa7ec0ba05bd0df22f7c87f1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1ad16a00f33fd4725908bb963afef3385b783d3ce3c2a46126ecc245df2384b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d98f42afc2f641c473fdab4f18aa21e1321e3f0c5e04690b64710e1d2b132b3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d11f8312bb748fc551176c80ea7ae9f3d54f8b1137581c57b7a40d24b0abab1"
    sha256 cellar: :any_skip_relocation, ventura:        "b61eb59748b8a3fac1785a52a4c027c5cd8c9c9eb2be803f4f83a4845f72b396"
    sha256 cellar: :any_skip_relocation, monterey:       "68251fb59caba579fc27a4ffe7b63d310f4132082319a761a320db7064ffb18b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80a3c2839d8ae2ec86ceac6c948dd788030e5d0107cac42a5952105f8473d1e6"
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