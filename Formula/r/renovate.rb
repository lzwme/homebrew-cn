class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.70.0.tgz"
  sha256 "f7293d1db705b9d3280be0b3f58c1f7c5ba95a8b198bf3887f498882e472b91f"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "936bbbc3dba305ae356204c2fef46b841dd4bc7c774fe0286340225db8cb7008"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44d3223a03a58a4119f2d712e50ff105666381069eed938e73ffe0ce0068b2e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33da8cf90c84181df2b00a714107b08a085727cdebf07db7a674a796cb4c922a"
    sha256 cellar: :any_skip_relocation, sonoma:        "dacdf3cb4d8f8e24102f06e5ac55240c578dacab09b4512e7bee5770d8e82ca3"
    sha256 cellar: :any_skip_relocation, ventura:       "ef37b2f99c9f4915e0c7a011f25137a0be8a709d520a517fdf0e295613084ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f4e13cca7b825f2050241d977641049776b042dfd98c3449e5f3c5ec58f5268"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end