class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.73.3.tar.gz"
  sha256 "472f46c6de9b5a170354d64356e84a270eee0e3fb1d62adae337416b3668fd09"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4eda10d0568c2ce8b7691ff9642c3ea9b920ee9d02005045bc72ec00459eb2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5169c6f083efc67869692f8822abaee02ddaa543b040449012af6ec5c72a079b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b66d8d58cd859771cfd3f671af5e0172d6e636861cbf0b7438503b400cc636ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "22519a55a2ce7747fe08aa9fa935ec6f9ad80876fcfb8979e4f647e34775c306"
    sha256 cellar: :any_skip_relocation, ventura:        "1a8672810880a4715bef88e51fb4a5516eecbdfaf9ba647929d7bf4843a6b340"
    sha256 cellar: :any_skip_relocation, monterey:       "047a86bd5f611950f83cf2dd1a936d0f988d08ae67bdb050ebe853c34a3788e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56af42190bd2374fb4a340c4c7502b2b14da1d4166034930daf309792c9033d6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end