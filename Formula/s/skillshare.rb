class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "422ec08db0033b16b931fb1a75d3cab573a81314b7151e8ca81fff48463a6388"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "371e978fa57152c4158d1ca3478eb006fabfc5fcb9b47bc25884464e28551307"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "371e978fa57152c4158d1ca3478eb006fabfc5fcb9b47bc25884464e28551307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "371e978fa57152c4158d1ca3478eb006fabfc5fcb9b47bc25884464e28551307"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc521a321687d73251b25586a38fff3a6d269b81b21344ad975f06f1850f65ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bdc066ff1802773e726e71083bd5d0c682a378f8cb849e2f5f22fb8a132911e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "961f75ff7b79cab1bebfb6a196242569af6475b8965149eebfaf400327a7e2ba"
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