class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghproxy.com/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.5.4.tar.gz"
  sha256 "3ffcbc099ce7b6a166bcd85b5933065f0c8bfde682844575d5c3cd7d770407ec"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f947ab49faf643c7c84ad62ed5fbc3cab271b62b79bc598a25902b8eda10509"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24c725039a230afbe65161300fcd415438b807f375d9c37a773d6fe70ddacaab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01a0d80855d4757d414a3256eb66560a86833d44c219e87300f4b37bfca711f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9f285c5cdca81bf357590ef9dd3411de02925e0bf7980d6e880f50c439adb52"
    sha256 cellar: :any_skip_relocation, ventura:        "112aa97a3d8d225f16627796c233dacc158be3169246130de96cab05bd1222e6"
    sha256 cellar: :any_skip_relocation, monterey:       "094a5d807f36a0c94f0676ce457750220015f9d31cbe87ac11604e80b60fff32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78884476c4e37d1a8d87111dd94cdf06da8054849af4231710e75224b580c6d5"
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