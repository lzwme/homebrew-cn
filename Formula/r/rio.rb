class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghproxy.com/https://github.com/raphamorim/rio/archive/refs/tags/v0.0.21.tar.gz"
  sha256 "41ae7ac048d3c996db28ab4815aa95f7e9d0301caa27e9e2a25d8ee3e0ad01c6"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5efb8cd30d4fb6c2dfba55ffe73ab5e435de5d4fb4964c07985d2875ed19706d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddfcc2e318d34b438842db722cf681494fd3b4c676cb09b862e057de99fbd6d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c05d76b3fc1f80b5463f600e643ce281830a72081051d40a0dd2ece74840f573"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9733e42519f79cffe8c7641dd18941ef075d9958eec7f852e581db4e9ef43b6"
    sha256 cellar: :any_skip_relocation, ventura:        "57887a334503b6e10d26d55dee40b3042d1660fb143ba4a0efb21df1e41b8447"
    sha256 cellar: :any_skip_relocation, monterey:       "b71df87c2199360360e8cf0145b4df8dd3c5b3f4fff95c06f6eed599690ee8f5"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "rio")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_predicate testpath/"testfile", :exist?
  end
end