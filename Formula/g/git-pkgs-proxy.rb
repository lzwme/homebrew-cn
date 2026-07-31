class GitPkgsProxy < Formula
  desc "Lightweight caching proxy for package registries"
  homepage "https://github.com/git-pkgs/proxy"
  url "https://ghfast.top/https://github.com/git-pkgs/proxy/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "7a158eec6a8d323d982a66b546137dafb54f6b21de42bd5608465c544f3b0e5a"
  license "GPL-3.0-or-later"
  head "https://github.com/git-pkgs/proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22a0dded1e64c0ceefe1a244d742e0fbb2a0f301c112812a2fa822fcfcff9d64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86723094bbee6daab05889f44f8fa53c2f268680142cc50c01a10320bbcb3a89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b43892dc87637576608defb2893360d0e6762979370d4df802af98e6df01163"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b4c7dc7580ab5c2750474f185f69d25b988b5a652cc1f7924a53fb30e6e744f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c96d11996a79e752ae4c6388ac200adc6e5d9d219fe2c51970affbce6f1809c8"
    sha256 cellar: :any,                 x86_64_linux:  "c7606230aac01946b6050056a90bace59542e49f6a7bd44874e5d748e15aef24"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"proxy"), "./cmd/proxy"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proxy -version")

    output = shell_output("#{bin}/proxy stats 2>&1", 1)
    assert_match "database not found: ./cache/proxy.db", output
  end
end