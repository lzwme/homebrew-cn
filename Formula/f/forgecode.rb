class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.12.15.tar.gz"
  sha256 "5f74ac55ff42f842d7941d05c64631bf7763af62559f78f3521f73966fbb375f"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dccd2ffdcd6ea78f8d224b8be6426a6bdb2da08fedff4cc43fa2dd575ff5c7b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b245b85e3471affad2b27d3b4d88a90f429dd37964f74279761e8cb8fcba5bad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01c46afe205a206be9da8e6b8185abe9753326aabcba32d270b3c1d1cd9d3f71"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f5cdfc4eb5a8b138aa3d9703a4dfe20746af438bc95f601219bc2cd289059a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9610614e41f2642227449426e54238fde5f7f05692d353910604cd859a041af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb13450e093b2023df67ea980fda469a10947b2f451f056eda007e90db9b69b9"
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