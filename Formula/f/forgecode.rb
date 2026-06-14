class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.10.tar.gz"
  sha256 "535aca768c10bd2a0c48454b22dbbef91524db0ffaf99e8a68bb52521bc23cf2"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "252c7142a93c033ccfaadc35b5c782f04e8777fd3fbd0b4c94478d4a359ac80c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9295f0b44450297d4dca81b9eb5ccf3713878a04f372cba0c90c0446bfa7d6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "154766b11045247358b2c0686b2baa3a5ad2d532c97f382f4ec5036b3b371fa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bfae8f7b2e97900ff782d3ccc5a02ae5e0aa6e3610847e61bc7dd648492261e"
    sha256 cellar: :any,                 arm64_linux:   "397d89d10b939cbcffda25ed4bbadd201f1bfceac32da06140944218ac12d6f2"
    sha256 cellar: :any,                 x86_64_linux:  "925707576b3b23009db7fd883c4b2064e447e906d286f55e98bf20cf19d8fd22"
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