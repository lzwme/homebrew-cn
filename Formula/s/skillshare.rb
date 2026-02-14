class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.12.7.tar.gz"
  sha256 "ae6f01d78ecbb59002cb562f60fa629a2fa8552c116fe7e71f3c49efd5996f01"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "350d553b911ce140b4e97a646e35121bf9c34183e17e39faae5ffd073f663dc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "350d553b911ce140b4e97a646e35121bf9c34183e17e39faae5ffd073f663dc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "350d553b911ce140b4e97a646e35121bf9c34183e17e39faae5ffd073f663dc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f4db6d74d891d43c4be8ac79c56804fb7e67f1411d8caf8a7475976bcc229c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff1252caa9a4e6e912f5d63b661a99a3e701f77f65c383af968f431b659e513a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2a360b5ab06c62c13a8a6cf492496d168eff0fcc3a5dc2bc5121a708ecfae58"
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