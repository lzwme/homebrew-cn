class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.12.9.tar.gz"
  sha256 "e1635f5460c3507a8ee02215929298e8fa526c6b34fdcaeb19352172ffba1f88"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a86dd234341ffb7b7ff78c2b76504b7a662dcd6399c84bd1996c3ff00ef853a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a86dd234341ffb7b7ff78c2b76504b7a662dcd6399c84bd1996c3ff00ef853a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a86dd234341ffb7b7ff78c2b76504b7a662dcd6399c84bd1996c3ff00ef853a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "18d34b8f05b1e092662137ed7fad8a8dd1904737be2799e29ba73e3514cd5243"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cc03ccb899c69b40927d19a707c05cad49e99d6e5fb2ea771eed2736104c51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ad1ce4e8adff60eae3d587ced7fbf26119c82e249acd1c645519904a5d50775"
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