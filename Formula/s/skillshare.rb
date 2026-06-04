class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.7.tar.gz"
  sha256 "b245b3a5593b93048577ae037d1f5a5fcf1e2013677f0191df5d375d343d4721"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3acd5d0506ec225c0f97209428a1238e3745d28db8ddfdb3799ac6ee6f1e197b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3acd5d0506ec225c0f97209428a1238e3745d28db8ddfdb3799ac6ee6f1e197b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3acd5d0506ec225c0f97209428a1238e3745d28db8ddfdb3799ac6ee6f1e197b"
    sha256 cellar: :any_skip_relocation, sonoma:        "76236f55437b0aac760ac67472680f1a667c895f67d0ca096c9e71590fa038ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31dea23e62844c493a3dde042d69de928d450240c1465548b5d7409204081b1c"
    sha256 cellar: :any,                 x86_64_linux:  "089743a8aac564a6e32e08f7e6286fe8835fd6bad32e24eebdc10443393b80dc"
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