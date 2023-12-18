class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https:www.massdriver.cloud"
  url "https:github.commassdriver-cloudmassarchiverefstags1.5.13.tar.gz"
  sha256 "5c4ad8f4a1d51bceb69883999008b5dd0ae2a321ad77e1eff0f1d0be90757de3"
  license "Apache-2.0"
  head "https:github.commassdriver-cloudmass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec6059e969a61da2996df44d224aabb75ecc4ce6c44ae87b9513d82e19365464"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d63c26dd17ffbc7f0115ae223f45555bc69aea8601684a4cf14790ec3d1a271"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9cc40211d97b2fc5fdf90fec763cb032afd460b4542d4a34bf85b0e81fe8bba"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e5d23e23d5442093af136f695c9df125ef1706b3546d26745a253b6b67d6c2a"
    sha256 cellar: :any_skip_relocation, ventura:        "482af2c3a6becba48e332b56cc7fdf85e02e376800419d3da818b2cca52ee2d9"
    sha256 cellar: :any_skip_relocation, monterey:       "eb2a0330365ae02dad6024ac9420a671ee2f67022050f6fafa485b6fc3c9ee68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5675d3075af68b050b066daa4e01b993f3927c4de50858475641334e005eef89"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commassdriver-cloudmasspkgversion.version=#{version}
      -X github.commassdriver-cloudmasspkgversion.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin"mass")
    generate_completions_from_executable(bin"mass", "completion")
  end

  test do
    output = shell_output("#{bin}mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}mass version")
  end
end