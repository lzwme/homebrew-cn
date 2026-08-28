class GitPkgsBrief < Formula
  desc "Tool that detects and reports a project's toolchain, configuration, and more"
  homepage "https://github.com/git-pkgs/brief"
  url "https://ghfast.top/https://github.com/git-pkgs/brief/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "6a425c3855981475711b6bf8cab09f2dce375d40cc18233c240311c0a74dd825"
  license "MIT"
  head "https://github.com/git-pkgs/brief.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24ac68e81a987626bafc198b2917436ecd4a96e531dc6df587651ba7d7e5197f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24ac68e81a987626bafc198b2917436ecd4a96e531dc6df587651ba7d7e5197f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24ac68e81a987626bafc198b2917436ecd4a96e531dc6df587651ba7d7e5197f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6968a1637dbcb9cbde8b94b13e909091b655f993170fc920d53fa51790893e78"
    sha256 cellar: :any,                 x86_64_linux:  "9ab2fb3a20c70589fd5b0244f5893f74685eae69439ad182b7957f2c4e7e852b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/git-pkgs/brief.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"brief"), "./cmd/brief"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/brief -version")

    output = shell_output("#{bin}/brief https://github.com/Homebrew/brew")
    assert_match "license_type\": \"BSD-2-Clause\"", output
  end
end