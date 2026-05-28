class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.19.24.tar.gz"
  sha256 "15aa36ea09be4584bb5f0fcfe261dcadbcb5459ade0a70287c635d3004f846ca"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da7efe05f439f4a5195ddec903a13830491e9f09ed3cfb981b350d3484bf3fbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da7efe05f439f4a5195ddec903a13830491e9f09ed3cfb981b350d3484bf3fbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da7efe05f439f4a5195ddec903a13830491e9f09ed3cfb981b350d3484bf3fbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e7b04006cc5869562e93a880a62e4b370092a884f402f14e4dcf6fc27599d0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62dc432eba6374b0fcadebc3b03b8ed785328ce176fe9c20650e4194a874074a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b102d86932469122bbb6505f945f613f950f817a01c7f146f06685bd2a1146ed"
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