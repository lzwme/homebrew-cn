class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.18.6.tar.gz"
  sha256 "a76d712d283d994da36420d901d1837b1f9b694acfe4d5a82819005a882e4a86"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e20ffc6598e0ec1379361f40408ec5eaa21b19059a29dedb43d11eaa716fa05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e20ffc6598e0ec1379361f40408ec5eaa21b19059a29dedb43d11eaa716fa05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e20ffc6598e0ec1379361f40408ec5eaa21b19059a29dedb43d11eaa716fa05"
    sha256 cellar: :any_skip_relocation, sonoma:        "4653d2fd53346c44c986f5b45a37c7d40909fe9e0f8783a4ee94e2e84a0ab051"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8bbe1f49ba3b2a50692949d8f1aa0de5cdbac1c27838526cf41c522e4ace693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4bc54a268a825327c4a756133d751a13315b0e53793d02907db49cb399d6845"
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