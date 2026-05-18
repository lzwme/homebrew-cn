class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.19.13.tar.gz"
  sha256 "10f6c640d5c8b25ea18d974e1f60fe0fde84186978722f6fd5ef22ffe284ee4c"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bfcb2f1f6fe3e4a41e524ff4293db319f0344bd2dac3777d353f4cbf228cec4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bfcb2f1f6fe3e4a41e524ff4293db319f0344bd2dac3777d353f4cbf228cec4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bfcb2f1f6fe3e4a41e524ff4293db319f0344bd2dac3777d353f4cbf228cec4"
    sha256 cellar: :any_skip_relocation, sonoma:        "480afdfc11260a1876a5dd9c5adf97d6e5f325d19c9c5468e2b7c6e9440d9287"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f357852a83cb621de52d0389c308e91e57676f8a25abaafe1fdb72c43c4c4a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "701f985e14191747ec03cb90c85356e215f57a01f6800f8ec0d70f6192f91be9"
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