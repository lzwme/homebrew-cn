class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.80.0.tar.gz"
  sha256 "554b7e5fbc8c79e88475a77c47d1f4466d51880d922423cbffac132dd029fadd"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8c398affa40b4491518626ebf81dd1eb41fa599485efbd4acfaa681952936e32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88e4cbf2ea8d8d4bf56342b80e0c242cd94d83869c9cb77248fb5a19d0d44911"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10ce1742a20669c6129a6935028f12c6b9c140c9bcdefc0bc543b604fde4301c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b571464d06221679db30d5a5744fdee3216beb0d08dcdecc122a18e1e35d2682"
    sha256 cellar: :any_skip_relocation, sonoma:         "14015dd6ed19c4982bc74b23868c8a3b9db6c4ff80d9f68df4503a1e55fa292f"
    sha256 cellar: :any_skip_relocation, ventura:        "a4d2a8c25cee34f425cc9a354f94350d23a092749181a1cfe8ee83356272aa5f"
    sha256 cellar: :any_skip_relocation, monterey:       "284b09d77a5b8215fcd83d66338709817379edb96fc9b71eb247652005f55787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5fcc24dc23846d6297a57e4ae1c4ea7e74f3308adb1501d833fd15ffc34d502"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end