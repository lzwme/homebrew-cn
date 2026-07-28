class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://ghfast.top/https://github.com/amir20/dtop/archive/refs/tags/v0.7.11.tar.gz"
  sha256 "1839fdcdc1b1c0db447a047c2e88d507c35edf7efe9456199b377fd44a7c927e"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97b9590f8d1a6d11bb946f88d0f10d36e6448de887e5bffe52247477c070c546"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3a5691cb2fe488363e50300650e84c4b1d42da5a166a302f1673f686a52dee0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d42859e9970df3155da93e6f6f2715e934390779ed5f0d91dd667c83a3ed17a"
    sha256 cellar: :any_skip_relocation, sonoma:        "359d56f84c51d75477f7a356ccaee936838b59a75820be9817fdcddbf1b8dcc0"
    sha256 cellar: :any,                 arm64_linux:   "a8a476d4cda45e0acfe38583d21fafc1423905e6fa06927e8a7ac8e0bca7d523"
    sha256 cellar: :any,                 x86_64_linux:  "22c2916e2998eb099644f06fe8f1b21c8498eb592b7672d88b6599df92ee25f0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end