class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.14.0.tgz"
  sha256 "182577f76604b94a4f635d5f3b147896ce9c681c5bb47e9f5e96b2d2718165d1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2732c7634474bf0eeeba64cd729454487706e0ad239a4554d5ae8bc791aef307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "024ddc93f3e544fc87cee303375b9d49d6a0a3ed1790930659fe75e9815e4e85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "789a76069eba0a8cdc1407cae5b27f6753c7fc8e63483723c2573dda8424a2a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ac057f6a9757613c48159a9b4b24e474e1c6dab340450ee86758d17e3205d95"
    sha256 cellar: :any_skip_relocation, ventura:       "c685dca10f107ff3f3de698cda4872fca83b733a62745332e115b3eb75e173f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39f3acba3cead91ada829e8a8a5ebfc9b37800b710cb7fa90f153c0225450323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "552e651ea7cc7578fc6ffe602b8769406c056cc43bce24557aee6a43d97b4587"
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