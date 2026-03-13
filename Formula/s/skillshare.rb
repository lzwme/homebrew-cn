class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "4035d38b077a57a356fa08ec57f4722b7ca99d6270bee35fb0260abe9fece788"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d76a60114da040ce8dd97a4125134816d7e6a4de7589e8d323b9d64676824272"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d76a60114da040ce8dd97a4125134816d7e6a4de7589e8d323b9d64676824272"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d76a60114da040ce8dd97a4125134816d7e6a4de7589e8d323b9d64676824272"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0527efbe7a42c4b87c70a81983928571dcd9aa652b78d0c9f57796cd0c7cb99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4b0ebde6c144677fc6da91666f6b2c3876afb3b72c810b7bce8390d55a3aa32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b7589d54fd4c5fd758566f8b5b648ed270c777b459f78ca9d01f0ed60e48563"
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