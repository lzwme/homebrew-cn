class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.74.2.tar.gz"
  sha256 "7951f7c4f270ca9a2c73c8c9b659bbc4e34712e4cd27628a053d86e75083e519"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc5199e2f8b2dfb600b9914c679ef09e83583205aa7ac93be374b46e8355b46f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed63a6a3926da318a4ed51c467dcd9d81b74026873d71ab722d30353234eb6a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb863b872797813ba4828820db985d8f48195dd6c88b1d83f4c3edf6f67973f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4150ff2e5fb84c62d95956d49a9b44067232878d1fb0c4ac9437850ad1614b81"
    sha256 cellar: :any_skip_relocation, ventura:        "bafacdfd36207012183078de90866d1c8fadb0693c9237b15245d7e3914fe57c"
    sha256 cellar: :any_skip_relocation, monterey:       "eaeb92666732b332069dacd706b8c82bb0a7ca6d65dcac2e1907ea37b0e74017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d07a2105d1bbe08179e0609efd9d15a7c8345d0fde4112632c0caa69757a5cf"
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
    assert_match version.to_s, shell_output("#{bin}grype version")
  end
end