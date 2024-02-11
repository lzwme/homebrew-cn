class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.74.5.tar.gz"
  sha256 "ec87f5de0e4b2e0c4c967619a658078285d995dd8d1c1ab02e51e3ca6ee06cdf"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c828b5867d40c815c0aab9f5e3ff8a3d43693f1ad1f0e8aceb5486b29a63e90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d3cae34a8fbbb2fbaa4110aa2925e3867d252dfb10994f24cc99fa2635edb51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9387b2b3c344044b1088167b4319a4ba67ce4b4d29254acde7a1ecee7e3fd15"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba343573b92dea29ec2177adbc4b3e7fc3e0a8e4f94819de0541f386db4e677f"
    sha256 cellar: :any_skip_relocation, ventura:        "7a0a527a9f5b109e7a1f9d1a76f13695edb527b46f6b0d7f0b01de661d8ec14f"
    sha256 cellar: :any_skip_relocation, monterey:       "a7ea20346743771d9dacf51172a1cf1bee3a7e2dd62c65396efabefd55870c97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f403cff2591819861c4ec8289984fb3ddbeded988eb7e2ef29abeb7eb2f278d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end