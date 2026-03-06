class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.16.12.tar.gz"
  sha256 "cb8ac09f6c70095ed462b4cc538c070d7ed957a297188a375a5314acee170521"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbe630f7bc60fc17f39f6b22df1e49ba010b8254096c779fd90caa893b79dbf7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbe630f7bc60fc17f39f6b22df1e49ba010b8254096c779fd90caa893b79dbf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbe630f7bc60fc17f39f6b22df1e49ba010b8254096c779fd90caa893b79dbf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fb9a3d39eb27b1aea647817dab8a321a4b29ed51fae126f7b76c76481abb746"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53cbfb7f76e63a042eb3d1b3f438fd3af199df0f527fbb32b85afe2acf495b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f07ed5361cf8668fffedb4c0f71adb1e0e310d43a260048171ed673282f6eec1"
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