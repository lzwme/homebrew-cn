class Librefang < Formula
  desc "Self-hostable operating system for autonomous AI agents"
  homepage "https://librefang.ai"
  url "https://ghfast.top/https://github.com/librefang/librefang/archive/refs/tags/v2026.7.27.tar.gz"
  sha256 "88213bb8a5ab48d91c74daf560dca004524851c83ef67bbdff69ec5d6abd2455"
  license "MIT"
  head "https://github.com/librefang/librefang.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "86f7e24217d2dba9357d06dba46377b80abc8cb5f331d3c28948be4c4cffdc39"
    sha256 cellar: :any, arm64_sequoia: "44f3023289e248ede4f0077d074e65d5640c481880fd20fa458a74d5898aa721"
    sha256 cellar: :any, arm64_sonoma:  "aa0b4af84c03b18bd21cd5a3953e7ba4b96193827fd078cbfc1613fe16dc8be6"
    sha256 cellar: :any, sonoma:        "508bec37a50046e0e32772fbe8e900756c3361760a78698572689f08c9792f21"
    sha256 cellar: :any, arm64_linux:   "fdad55f49502191736a0d3d17d0d83826fad317c3c9c4bc2756c5e5c87cae96d"
    sha256 cellar: :any, x86_64_linux:  "44c32b5cb0c9b512900bab6cd8969b232011bedac624216e10b6636a46dc4c80"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/librefang-cli")
  end

  test do
    system bin/"librefang", "init", "--quick"
    assert_path_exists testpath/".librefang/config.toml"
  end
end