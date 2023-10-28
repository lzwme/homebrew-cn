class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghproxy.com/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.5.10.tar.gz"
  sha256 "43aaf7aa59413d4948e9e40b02671b85e122734508c8cda7c32be7a29b17a064"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "121c5c8bf358887497ffba6c17ae0133ddc4615ee033457e1717937470f0b903"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f0fd6a2c65c0a594191ef00f8d827e6981445e1472dbbf4564b468db836e36b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddac650aaf9b30edec6a5909a48f59c0bc59788075f81c68e89b80e57aedea67"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf0f97c97d7c3c091aedf52e04eeea964aeb307bf2303ce7c4a5272dbcf87b5b"
    sha256 cellar: :any_skip_relocation, ventura:        "12d0eb7c80128ec49180fc08fdec7ba85321523c88e6d8cd6c1b0f8e23932eff"
    sha256 cellar: :any_skip_relocation, monterey:       "458acb89f41c429809deaf6ec9f2e31743f70b5798a41a23bdb545771703e605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17b82ffbcb5f9efe39bdad6676ac1c3d4024f7c01d8406c26970c16121c715d0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"mass")
    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}/mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}/mass version")
  end
end