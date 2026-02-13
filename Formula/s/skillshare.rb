class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "d01571e9cac15981d8bda13eef7845eae8d6f4c83aa7382aedb5a18de2423c4d"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7da2f39152bb71139c550b202f42ee27c700ce60fe20c99dc8968e24967c9fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7da2f39152bb71139c550b202f42ee27c700ce60fe20c99dc8968e24967c9fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7da2f39152bb71139c550b202f42ee27c700ce60fe20c99dc8968e24967c9fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1a2ce997073741ec043e33433b7bc4891562a1a8508b825f5aa0e7e35da0f6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a100d353782d93acdb07ea08d6cbbcecb402d5a822cad01bb721d261a24672a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e80c0551bae07896d775043925611f8e02080948426225686dd80df4bfc8b1"
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