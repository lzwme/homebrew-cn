class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.18.7.tar.gz"
  sha256 "501064ceb6867b16b4a6a3a6ba2a92e4fdfcc4a9e7a78f0b6b2e1f98253b9337"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8df25a0f232b3edb2ab8611709fbb4034799e663e08031fa89ad3a549f7cc690"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8df25a0f232b3edb2ab8611709fbb4034799e663e08031fa89ad3a549f7cc690"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8df25a0f232b3edb2ab8611709fbb4034799e663e08031fa89ad3a549f7cc690"
    sha256 cellar: :any_skip_relocation, sonoma:        "44469d0170da39afc093cda5f340cb9a35447f51d57ebeddf23051e3625c2ee5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d7b00c8f6905cc8aa19fa851b34d072e7fcde4efb4459bb8a9f8158f8d5ab0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2065310226e0498bc442e4a0241d1f37eb48ca90c9f8a4e026e0509c7d65381"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end