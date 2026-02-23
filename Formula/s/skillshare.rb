class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "c2b29a9bf8fdfc232cb65331f3ccbab0481c3d72724fc7c7f5da260f559e98b4"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98cfe7829ac8ad31a486f5000730b9f3074c6967d846c7fcd45a2b9bf9080ee9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98cfe7829ac8ad31a486f5000730b9f3074c6967d846c7fcd45a2b9bf9080ee9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98cfe7829ac8ad31a486f5000730b9f3074c6967d846c7fcd45a2b9bf9080ee9"
    sha256 cellar: :any_skip_relocation, sonoma:        "82994a299ccb00fd04ab10708b95938342cd159f0d9fec38dd500f8acb3600c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ca615fe32ed9a476ea2c9c79b20bdea450f027b58fe9df694eb90553fdb8020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98ce7485b5a353d7de9e0f6ad41b5d190c8d4871852e23b3e83bcc7d0a90fc83"
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