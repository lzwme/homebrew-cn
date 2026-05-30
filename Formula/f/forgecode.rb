class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.3.tar.gz"
  sha256 "bb991cd9c90d9b939ea39ee0f61ca635037dbd8fecc8a42995f6c403749ae269"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5eb50be9c556a13c15c8a2e1dca0e883a0000760674d65b9eadd3e02338f858"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e24c3ddfd157e6c6a4aa5e10eba2c6703dbf529d44bb1998679d9f6ca8179a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7dfe9e4a6f4548e84deaa4ced8bb9a156743d7b5fc23ec49f220b203bda52cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f49a9257657a62d501fe43c6020e7fdefd12ffae46be5264e8547891d1f31629"
    sha256 cellar: :any,                 arm64_linux:   "2244d9014e012ac06375feb827eaa8bf5c87cae826ee565b5d6618f2d393e0f1"
    sha256 cellar: :any,                 x86_64_linux:  "ca611e1116ded4487b4a371a585adac95928b234380b3297ca302d78cdf6e5ae"
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