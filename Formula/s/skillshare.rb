class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.24.tar.gz"
  sha256 "605dd957b38118dcbbf7697913f79ef10b4f64575d1c5fb38380f36c185be371"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f99c409e8434916fb494196383a82f8519bb220f450de29b38a31ba89e20bd5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f99c409e8434916fb494196383a82f8519bb220f450de29b38a31ba89e20bd5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f99c409e8434916fb494196383a82f8519bb220f450de29b38a31ba89e20bd5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0826c1b91ac4a845435342d28b1a2346c7ada9ec6bdbf83c13936a2c2d4e64d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9768c3d5203eff8dbf869147302c7ecc46abc3ef4145230438305dc23e705db8"
    sha256 cellar: :any,                 x86_64_linux:  "ecf71769844d7a012e561abddc5060d392da56d9ee452647ce72d5b944d54547"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end