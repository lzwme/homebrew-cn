class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.25.12.tar.gz"
  sha256 "ecf4e76ea6ce8282d3ace35a927eb94f6a9b9d070d12b9a36ecd54b2b504a774"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d8cf306faa3ec26452f6def43790ad0b2cc632ce3a5174217d230919f2dde6e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d8cf306faa3ec26452f6def43790ad0b2cc632ce3a5174217d230919f2dde6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d8cf306faa3ec26452f6def43790ad0b2cc632ce3a5174217d230919f2dde6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "49f203af101d89fced86b4e5ce2f53a82d7cbd26dac70beaed35c79d88bc5ad5"
    sha256 cellar: :any,                 x86_64_linux:      "6227524ed7b011645bdefeb309ccf2cf0825e4a4f06367e4fd2b2148410a123c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end