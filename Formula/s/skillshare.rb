class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.17.6.tar.gz"
  sha256 "527decbd366f93e2d24dd194753a366eadfa210f55c11fe66d95b071ee7be718"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f3585e15e5bdd3e6d23cd92eafb09c86ef1d9b44e743c36a65d655d69446650"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f3585e15e5bdd3e6d23cd92eafb09c86ef1d9b44e743c36a65d655d69446650"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f3585e15e5bdd3e6d23cd92eafb09c86ef1d9b44e743c36a65d655d69446650"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d1506cbb60c61984553e635d2a5f21fecd5265f9837e0d2f00e4adda45c3c34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "561f0c3f92ee7ad65e226074a8dab867d78a8750f97ee65f66d355d92f751c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16db3cf06497f981c0f32fdcb9120d809b907828146ae7c07395342c996b3da5"
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