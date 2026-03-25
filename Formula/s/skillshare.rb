class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.17.10.tar.gz"
  sha256 "6ba472461fa134769033230a945210f3a507272a5e81d1daa784fa2679c2e041"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5c6b84deaa0eaa7c9ecf2a8b4bc2e805c648d26d27f11a8cc33b673cb1dfbbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5c6b84deaa0eaa7c9ecf2a8b4bc2e805c648d26d27f11a8cc33b673cb1dfbbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5c6b84deaa0eaa7c9ecf2a8b4bc2e805c648d26d27f11a8cc33b673cb1dfbbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "43fff11b0b9610bbd726485cecebcceaf4b495cddc36f67cd2cf3c853c2fcc17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b15bfb25e055469fb9ba562b0a2d8831e6894c18a23a8dbaa9cc1c8dc357414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddea3d448f0bc0c79539156ce1694db55045324a16e52bf265a84a2d2526efd8"
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