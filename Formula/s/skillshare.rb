class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.17.11.tar.gz"
  sha256 "770a51d116c7350e644b29c61957c308d2585d611ddb32159e4977e92e77aa11"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "804d9cf02ff25b957bae7c13609d40215d5488e4081b88cfb7fab2e1eb5b74e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "804d9cf02ff25b957bae7c13609d40215d5488e4081b88cfb7fab2e1eb5b74e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "804d9cf02ff25b957bae7c13609d40215d5488e4081b88cfb7fab2e1eb5b74e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f949f6dc39b56cbcf185f254738afc6460171ba43b21a035ffc904572a2e62ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "626930b5cb4406512471e66457217a5811d7239796b3aef9a76cc17f55725f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e72d9b1c0a389ba971d5401041a4a27d7f80ba23ec0b1d7db4d36de3ccf5e5d"
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