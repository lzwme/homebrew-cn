require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.103.0.tgz"
  sha256 "bd521936c29e3b6a8313fe3f3099bb7fe23c17747b717a58fc473e46869dd880"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256                               arm64_ventura:  "e6038101fbcdcd8f5f125972028c2f07fe3dc4285e87ecc660e6c7662dc566c6"
    sha256                               arm64_monterey: "2c57cd266b493ba5c1ca9f0bdefa3ccaf4a3fbadbad98b6767209dafeefcb2ac"
    sha256                               arm64_big_sur:  "cde4df8b007046efb38c49727e316387f7004085b80ebe260d155cd62b71480f"
    sha256                               ventura:        "98b3e5e5727c77f92201f36746167b5fd305ec9a2b6f15b1d3f58d1180b31aa4"
    sha256                               monterey:       "f466acbab3f0553958d58d1820b6562bced011564d8bfefe8c199092d49b9919"
    sha256                               big_sur:        "662e0d503dd250a45fbbe8a364820f7e7057f8153c75c477389532faae1bc0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eed218852c84328b1e386d9837dfceed41bb92d73ec08dd7eae1eff000dcdced"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end