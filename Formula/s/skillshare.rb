class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "f5d950d02ea36cb9e341b7716f5c73d035cd69ee69a2fb9a49406549f66fe169"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ca6feea9275b63cfaa014d7cbc4b5bed9aa07657d4099e0e5b7246da7a080f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ca6feea9275b63cfaa014d7cbc4b5bed9aa07657d4099e0e5b7246da7a080f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ca6feea9275b63cfaa014d7cbc4b5bed9aa07657d4099e0e5b7246da7a080f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c23da9b6cd21582396aeaa8a1357eb6cf26abafa0abfaa905259495626b3000c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fd5f4cc1634183a08e7723f3687275c1b6a9b498f3b7a4c7b4d78ac3d4c7999"
    sha256 cellar: :any,                 x86_64_linux:  "a657eca08c5a7948b190ffdebf42bcb180605d825e93fcd86c669761dd664ac9"
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