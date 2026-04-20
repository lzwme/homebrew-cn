class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "15f989296cf70912bd3459fca1c0efc08e06c253935089d7d757ec28d2acbd39"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8151be0ded0e6d894863dd76527851f42d29b191ea4f18dece789cf3cbec9104"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8151be0ded0e6d894863dd76527851f42d29b191ea4f18dece789cf3cbec9104"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8151be0ded0e6d894863dd76527851f42d29b191ea4f18dece789cf3cbec9104"
    sha256 cellar: :any_skip_relocation, sonoma:        "80df94714c579582a24b44a7ecce28279aa15ad13e24fedc285a33abb423c5aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82ed4428dfb96ec62a8ea298e0f356233ab54d816a090d7060f93d2bc4383f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "493b556f0a0a98bbab8952e872ffabf46300b14f5d034ee52dd56954d8f33d0e"
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