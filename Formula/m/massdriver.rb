class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https:www.massdriver.cloud"
  url "https:github.commassdriver-cloudmassarchiverefstags1.10.5.tar.gz"
  sha256 "dfcf0634b83eb08d5954767bb3e9531bea0278a6110239c03265c4595af7d497"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61fad08329d51a25470f5ae929aafc448a79ae3e4554390acbda0b927c995510"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61fad08329d51a25470f5ae929aafc448a79ae3e4554390acbda0b927c995510"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61fad08329d51a25470f5ae929aafc448a79ae3e4554390acbda0b927c995510"
    sha256 cellar: :any_skip_relocation, sonoma:        "47daba8e4977b4a0180bad067095d60cd0b05764209e484ac69fc2f463116896"
    sha256 cellar: :any_skip_relocation, ventura:       "47daba8e4977b4a0180bad067095d60cd0b05764209e484ac69fc2f463116896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed7222d5103f7e7055c91edfd2a6f334327b82cbc8da89ef1b8fa09a5e5c8a1d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commassdriver-cloudmasspkgversion.version=#{version}
      -X github.commassdriver-cloudmasspkgversion.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"mass")
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