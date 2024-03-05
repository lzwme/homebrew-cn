class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https:www.massdriver.cloud"
  url "https:github.commassdriver-cloudmassarchiverefstags1.6.2.tar.gz"
  sha256 "8903dcd92dcb26a8876ff7107d50217aea0b8db0ad9566e08442212995f70db6"
  license "Apache-2.0"
  head "https:github.commassdriver-cloudmass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78df2e96ea6c58e2c05d1b138efc5f38a8becfdc9d2a6f491e5613e238305e93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deadb09889b09989f3c05d44f1ef2c94018a9341886df12fe47ef988378322f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f003d98479f3cf5e664d1d3bb6b4a63dc29e56295435046b4909578f36c22d7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3af572dbc1159691ea777a79aecc3f411a8f71c893bb0fa89be027e517ef9169"
    sha256 cellar: :any_skip_relocation, ventura:        "24b913a709ec8858b2bb69772d737ca7c09ecd0f33d400150bedcfac1593e9f2"
    sha256 cellar: :any_skip_relocation, monterey:       "68e0928afacf45dc0dd4402faa0cac99651084282cbe1f4ece7f5f0f0047af1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c34c6b1e77df0682f54f367670a0aff087cb9c7bb746cfa1a59f0e48131a501c"
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