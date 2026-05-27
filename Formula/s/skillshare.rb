class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.19.23.tar.gz"
  sha256 "160c96f5d0fa58e9d9e285f4b2e3a1a007ea3fc1c1b40a32bed236d43c113d08"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1cd2888b6d614c2792dec30a1555d16371084fb7d14b415db3f90fb63baf1cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1cd2888b6d614c2792dec30a1555d16371084fb7d14b415db3f90fb63baf1cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1cd2888b6d614c2792dec30a1555d16371084fb7d14b415db3f90fb63baf1cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e61da24edcb6692f7e287479f57b7e85c25cc2c4a8723f22f957437e95213a7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c1c8a6b1913a83e2662639ab684c6ee977261ac1cc76304a887e796c92ef50e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9d4ee11840c8cdce961bbaf067486a254b894eb2653e91d767e6a61e99097ec"
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