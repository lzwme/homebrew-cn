class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.18.tar.gz"
  sha256 "5727cd0a6f685e59dabbd0ceee9a39dc8b5192c0ae36754c147da191de312ec0"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f780b75fdd35e33444f5113c6d05c1daa58f72a8fb24bf04f370257cd40dc5cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f780b75fdd35e33444f5113c6d05c1daa58f72a8fb24bf04f370257cd40dc5cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f780b75fdd35e33444f5113c6d05c1daa58f72a8fb24bf04f370257cd40dc5cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b819114b84fdf4d251aceb38a767900f89eb395959f6aa0583e9f561cc296a9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bc80f78479aa8cee8c8336675dbfb26c69e05bd1ac4ce48be14b246ca147892"
    sha256 cellar: :any,                 x86_64_linux:  "5de0741987b66b74e26214ca9e7f48e47c31e26e7c1a2706f8660ea93f1eff93"
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