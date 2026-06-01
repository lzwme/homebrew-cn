class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "11f3a2aa54f59b928402e8d5ffc38aacfdad992ee6481f541814af2feeb1d792"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b110673283cc184feccb0beee31828a38e4c2e9846b3132c8905851b7ccaa9aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b110673283cc184feccb0beee31828a38e4c2e9846b3132c8905851b7ccaa9aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b110673283cc184feccb0beee31828a38e4c2e9846b3132c8905851b7ccaa9aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e1baf08409752719d8e31b766b74867d28373be43b86ad66daaadbbb517fa79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e245ea568a0b3d5e3fcd97c4e745e42dbed9163c6c60cbfd9298340d8cd4066"
    sha256 cellar: :any,                 x86_64_linux:  "124c480b0018d8a691ee14fc8bfb706eb6967d3093be443833d5e7cd9879700f"
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