require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.80.0.tgz"
  sha256 "8711723668e16466c2a3e58155d6d679cdbf485c5b11164277a9f6f0cbbacd77"
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
    sha256                               arm64_ventura:  "6853ce417873b560aac6e00157d40ccf2edef00e24941ddc9d3e41c771164f20"
    sha256                               arm64_monterey: "f0a0839d2358786113566cbd6d14b54a0eb1c8e3efad43629f923316a54eacc9"
    sha256                               arm64_big_sur:  "4378bb32238c0c9ef8e19610aba4ad164ba3d58a3fa31b35f2717f670a78aa45"
    sha256                               ventura:        "335b300453c0fe85dc8a95b4b4ec98fab9f4fdfa978c423b26d8940e1232908d"
    sha256                               monterey:       "89d280f8820e25616e0e6fd5d958a055e0d2658bcef9d6c2b483b1b9e5958c03"
    sha256                               big_sur:        "3934acc05e1b25acf071b7bde81913ad59c93db31b25064d5821bdcfb688c418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c90974dd0caf623a08571de33883ce1fd77bad854691acc82c5088b77cf0ee87"
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