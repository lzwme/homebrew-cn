class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://ghfast.top/https://github.com/cpcloud/micasa/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "8baeaf5a155a02356a8fc60e1f0bf2cdec7fede328dc04590b42acd1dec5f1fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2618463e67d1d5fb847ad9471c005e4a685655ff649f291647156f0580eb64b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2618463e67d1d5fb847ad9471c005e4a685655ff649f291647156f0580eb64b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2618463e67d1d5fb847ad9471c005e4a685655ff649f291647156f0580eb64b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "89069d36c3519b6da1e3fecae37bf856e4b94b20e3697af92ad57aed36a0f73f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ee20247f4aa7053a10d5d6212feb2c4dadf793d233722addce9548d5fdc88a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e23328f11e66265f53785bf4f19547a2481de867f6ecf2862c4a6c121cbf605"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    system bin/"micasa", "demo", "--seed-only", testpath/"demo.db"
    assert_path_exists testpath/"demo.db"
  end
end