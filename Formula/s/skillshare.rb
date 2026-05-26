class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.19.22.tar.gz"
  sha256 "1495bc6320a0c2dd7c6b68f44c937300dffbcae1db055c009a9318260bc13000"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ee317347a82d5110e7a61e3b24faeb08639d08f6dbd549295414d4609c15c59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ee317347a82d5110e7a61e3b24faeb08639d08f6dbd549295414d4609c15c59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ee317347a82d5110e7a61e3b24faeb08639d08f6dbd549295414d4609c15c59"
    sha256 cellar: :any_skip_relocation, sonoma:        "71e27ddd222829e86f6c21939c5f11df9602503ce9191af7c87e7816a979358b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "453dc4b8af220a18b24290cda82a08c150cf02205e1de619c5c2687841ef2a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f349864d62fba7a336f0e213aeb74be0c78398055769cc4857f1ff0a00289c3"
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