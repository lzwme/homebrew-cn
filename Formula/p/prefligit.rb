class Prefligit < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prefligit"
  url "https://ghfast.top/https://github.com/j178/prefligit/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "6a920b6d7913d36085624c1f211024c62815dce8939a2f20882ee36dcd47d8e2"
  license "MIT"
  head "https://github.com/j178/prefligit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1facc981048579f3594059dbe02f7fac6ccefda017af1373800e5c7debb42b1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c760bf0ef984a4da5bbffe01efedb1042b5d9f1008456b55d219f2747a6981a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44de00a6e0b7ba48de91cd53e130ea203b9f861863118a152929232c14295415"
    sha256 cellar: :any_skip_relocation, sonoma:        "95a99331f63b3da41f4f2d04a86647713a1ea125904c4d3c7df974aef2158400"
    sha256 cellar: :any_skip_relocation, ventura:       "7041544a03ac3a6749989ce323bc9613ab93adb8b99409467d49e413fd23a8ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a0d256e9a0108aec1224eb0ad6683cf1fbba0534a4e767c0d4799f909a68b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d73013aabcec230a3b74a82437fc74c1ac4ddf8509e338a18700acb5ad67a2d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prefligit", "generate-shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prefligit --version")

    output = shell_output("#{bin}/prefligit sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end