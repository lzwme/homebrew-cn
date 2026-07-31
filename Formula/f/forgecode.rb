class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.20.tar.gz"
  sha256 "9da1486559e4f03cc895d3c4bcd095d8d1e7ec87fbd28c8eda99a6bb7df64251"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2534999754e8ad11173e5d12b6d3780f390d4016c86a09a46744677058083c02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f18b6773889a2fadd072aa600f52aaa00df8826b4bff0ef8770248f712935aea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba9654bd08a336c4aa7556929fc363127ab3ad3997da33c878d135f4ad6ea3a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "84386870bc6f7a8284c9c3a920aa3d42f84fbcc4ea3a278c93a02ea800c1e63b"
    sha256 cellar: :any,                 arm64_linux:   "2e782a7189c617939c8e7a6208463c05ef3c43033bf172b160e4501608f27130"
    sha256 cellar: :any,                 x86_64_linux:  "e9de64e08a58f7d4e1daf6f86dd9ee8c8abf88d13638688dc670dc2dacbb9428"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end