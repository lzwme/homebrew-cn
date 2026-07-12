class Soar < Formula
  desc "Fast, modern package manager for Static Binaries, Portable Formats and more"
  homepage "https://soar.qaidvoid.dev"
  url "https://ghfast.top/https://github.com/pkgforge/soar/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "dff993995d9f55ba9f0ecbba7736efd59e6a1f436b1a48c8dc003a57692bc076"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "9e583b9e274486e1d452c382d0e75778c8cec9c1e00f13373009012323f742de"
    sha256 cellar: :any, x86_64_linux: "ce6ee029887903dbd4fa943d5efa3726e7fbe13487f562348d9db7d9d6712de9"
  end

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/soar-cli")
  end

  test do
    system bin/"soar", "defconfig", "-c", "test.toml"
    assert_match 'default_profile = "default"', shell_output("cat test.toml")
  end
end