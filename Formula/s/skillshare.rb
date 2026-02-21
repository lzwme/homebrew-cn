class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "db088822c18b790c2472d6027c4a494df4a7286463d7d70ed4a927238c438b12"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ffb489d6c97c786564a9647192086700e5f10c138ebd544666cc4cd029fb322"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ffb489d6c97c786564a9647192086700e5f10c138ebd544666cc4cd029fb322"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ffb489d6c97c786564a9647192086700e5f10c138ebd544666cc4cd029fb322"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb46276ebd7aecf0c899416742947d3671e183c8fb651f96fabbb8e67f80a6d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd3203f6a55a901f6a74a2bddac80a0b3fde3690a1d4cb9267bae415a8a64f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8daa91ca736b8638ff5d51558bd5a42cbe6d5b419a43f8e7b145c0a904343b90"
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