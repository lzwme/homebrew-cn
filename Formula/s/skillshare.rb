class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "433d9fbff7b80f51991daaba0d0375cad4ba2bbf07101106bc031da7b7e678fe"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33e322280a469e9cd34156de80b4dad8194236a2fd3989e16335e3ba581112f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33e322280a469e9cd34156de80b4dad8194236a2fd3989e16335e3ba581112f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33e322280a469e9cd34156de80b4dad8194236a2fd3989e16335e3ba581112f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad22c595fc4a6b584562a049dea3d75265c56219a61a1b009b4a90a623218ec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fb27ccd45a0e56f35ec0d6b15e1d2287f858a6a86eb456d7eb1a87a8be1c15e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5654e3e857494659218ea90c02cad8e6ba3078ee6811b54d2145388e7c72ccd2"
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