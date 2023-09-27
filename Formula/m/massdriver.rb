class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghproxy.com/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.5.1.tar.gz"
  sha256 "d527b7c45cb225915340515420a2fb3f33b73188dd6bab5f09f5470cd1378294"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bb9ae95be3cd7ad384c9e7e454bea9a35b7b6196b7412e16588bef4c4b649e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15ef2ce9d0eb24e525526fa6a25cc882a86dcc7c891ba3a11c055a2930b654dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2ecdd021527c4997920a57e297bccfe2c2e0e7b6528e669cda9772c005a57d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "677bc465cdcfd2dd2232bc57b47dc84932562743d9844e795258b2b89c78cb48"
    sha256 cellar: :any_skip_relocation, ventura:        "8ec5b4ed9901330685d0d37e39ab632b27ddd79238ff06d11206cb0bd56e90e4"
    sha256 cellar: :any_skip_relocation, monterey:       "f7e283a6e533afa447dffa5c46cf275d819665b4dbbbfa90ac1aebc7a511ce08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "648b74545add8b6bc652b11c6a40db592ace59f3f9aa778ae431dd124efe8699"
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