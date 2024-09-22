class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.93.0.tgz"
  sha256 "0fd53ba09df5be434e651f84930b7336aab927f0c06c1a58063c89185b89b8f7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10b9543e6b43563ed71ab539e459c6eeb6dd3fd454a85586c73ba6095ee8712f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88196aeff8b1be3e22d1131ef80877e597abd02a67ccfebd094e6daeec2b74a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8e8b0bea79a71edacd2459e6b7fbb49463f62c8bef93a79a9feb4df82e38efa"
    sha256 cellar: :any_skip_relocation, sonoma:        "30973ed1c754280ebd8825e1bce354d5c894c6082b9f5def73ea36721a162c5d"
    sha256 cellar: :any_skip_relocation, ventura:       "71751b3671898490298edb7724e3cc70614ca3d0de875b39f131b3cee75d125d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b85c6f398263560e65461c2734b75449f8a281414d631c9741227569ab0926c8"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end