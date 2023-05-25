require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.100.0.tgz"
  sha256 "e273a912715d4612714ca352fb348df3c36dfc9c9d9febbdcc937a61bddabd24"
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
    sha256                               arm64_ventura:  "db3c5fc4f2f45a4bc4039b785af0fb36d445df00b93a020fc9b81a8152568e5b"
    sha256                               arm64_monterey: "595d06ab4c64f8646341bbeb22f476e9d97958937adafd4a93b6dca52a344c55"
    sha256                               arm64_big_sur:  "a2aaa3063bd1c7d93cf89f6528a125bc5dad18b4e7afcc49f3498cf98b694e71"
    sha256                               ventura:        "6f3ac4c853db17425a4ccbae34004f413ad4d1fbbd3c39d1799421e2f245ec73"
    sha256                               monterey:       "ffb12f1199009e957fd7e3f299c105c5246dffe6229122dcab82462bf456d613"
    sha256                               big_sur:        "1a88495a84291281d17d8b2d8330f823de4cb6acf0afa6ba4d1ff299edc9df4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "811aeedce8766a4efe3be3a306aa3bf1b47bb74fb3fa3e145d5513c38f6c1d41"
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