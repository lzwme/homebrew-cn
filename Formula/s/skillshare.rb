class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "78f0fbda91559ac45814bf88001609c39293be2886a9881d3b5d51c16e6b8ca7"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7cc1034b55d629737cf5dd2d315c0f6e24ec7d67d7fa789b8c782b2ba672fc7e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7cc1034b55d629737cf5dd2d315c0f6e24ec7d67d7fa789b8c782b2ba672fc7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7cc1034b55d629737cf5dd2d315c0f6e24ec7d67d7fa789b8c782b2ba672fc7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0f2c690fddb9cea76c558ef9d7bb034f03670ca2e750af3a5328b0ea23a440a9"
    sha256 cellar: :any,                 x86_64_linux:      "3737940b018b81edcd821d90a8af74c4b68e25a60047a58fafd2968b2f851c54"
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