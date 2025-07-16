class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.35.0.tgz"
  sha256 "8451ddc9e22299d6c300d43763c73dcf953b706d9fad56bd6fe1113b8a67b8d1"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82943e8e9bcecf0ac68efbe22b21769cc1c61a76b27f5c28e61f4487ef2057b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "389641aaa27aae33c0600e34ad409dd67dcddfef0dad254c83ef728e6a1c9833"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bba5f61ccb857f011a3da51f16dee662dd035d4f59d127acedb6f9cbd78675b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e16ff44bca547168cfd79e22eb1c09010f22aa0f79adc591a611e01945a1468a"
    sha256 cellar: :any_skip_relocation, ventura:       "acf25c66247ec4e1d86a0888dcfd06b7d77e57c80c1f51e442540deb8ca7042d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4673f24803c3e70077df5768e0e20c77fec2f53fdaa09c1cc1e3e2c04bc2d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56330b2b7dc93d33c86ba22760cf670102db2064cee739169e2c5e6b731b8b23"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end