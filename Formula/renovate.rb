require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.31.0.tgz"
  sha256 "f0d9ce006e3087ba342e392e964ea4be2232f66527a0ab5e8ed3eda49ef79993"
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
    sha256                               arm64_ventura:  "2ce43ea5f5445b2184a902a3dad2e965af32ca647a160bf412d4ce391b8830bb"
    sha256                               arm64_monterey: "7d53eb4a8f84762925b212a7908bae1b46d25ce15ed38604cbc16610abec2dd5"
    sha256                               arm64_big_sur:  "9b59368e946f743846dc6b79f3153efd11dc54c729115b41f3d95cc55e0b9907"
    sha256 cellar: :any_skip_relocation, ventura:        "7fb0f7328976f33546a19a089f5dbb138feeb6230f6c3a93d29ad34ad1d2cb95"
    sha256 cellar: :any_skip_relocation, monterey:       "d892fc434244db48971300f241101f228003463772eca9bc0d5e725c99a2851a"
    sha256 cellar: :any_skip_relocation, big_sur:        "09aa2a11e4638be2d73ef44dc9536bb7f173899f6eefcf90c8d7b1f511d2c3ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97782ae360db1f4e3d9f9a1206046f08606b7b115d8ae61eabfacaf67012f4e3"
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