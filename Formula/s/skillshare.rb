class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.13.tar.gz"
  sha256 "8e04fb6d8e9552ddbe56f287ab4e1cffb009f01087825605e35489dd022507c8"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbb268c7696b650b8a67732cd941f0237dc17b8e14ab5e839b9035b020afb954"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbb268c7696b650b8a67732cd941f0237dc17b8e14ab5e839b9035b020afb954"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbb268c7696b650b8a67732cd941f0237dc17b8e14ab5e839b9035b020afb954"
    sha256 cellar: :any_skip_relocation, sonoma:        "2edd4bf14fa9e654a5dd02bb267fc1cebd6820643c8f7325c8821f3719abf17b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52bea94caf16b3f55bd2baf81db4c91e27145da30a8e34011b48c78baf4b06a3"
    sha256 cellar: :any,                 x86_64_linux:  "5eb8cc87caf7330dce34506f4838353787e8f2d5b43d816b112ab96e3e186ff2"
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