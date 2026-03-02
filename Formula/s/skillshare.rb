class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.16.7.tar.gz"
  sha256 "8a8e2268c13f449bd9c50d0cb4913e908541f67070db5433901138aa0f1aba69"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f3fe6d13ab8613f9295bb886d28460e8159f4d920b6ea88391383d540a84255"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f3fe6d13ab8613f9295bb886d28460e8159f4d920b6ea88391383d540a84255"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f3fe6d13ab8613f9295bb886d28460e8159f4d920b6ea88391383d540a84255"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a7dce6134044eaefbf4b126c4e1281db79da8dcc354ce6c7f63d45632c8888c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e6f4a038ae9463ae6daebe36bcc6fcf17c40d025417175e6022d8d7f1e3802c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9f4d591fe79d5e1a67dbc2311a4a65e379b293de5207ea2741a88bf64f4530f"
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