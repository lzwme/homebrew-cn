require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.131.0.tgz"
  sha256 "0a330a80b17d6c227bea0da57bab028c670cb06803bf987256ea3d6fdea92893"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b281943b773a289e679a98c85f7f3fb771b9faf206e851e340de9a8348c85eca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59e6feb25b228f8cbe57d36cd96d9ac0de479d711cb1ab664b32b6fbf0f5c664"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58f97486f3f31d73b7203fc4251ac27cefa4af7a75899f8c6c31dfe8a8fed300"
    sha256 cellar: :any_skip_relocation, ventura:        "c02a8c942402798ec55f9db632a6869bdb9f5bb5c4b8b99c733b5e7d70a60a68"
    sha256 cellar: :any_skip_relocation, monterey:       "d85d362c304b3f6e16ee59b67562d44e4ff2c163a50663bc85eaa6236291564b"
    sha256 cellar: :any_skip_relocation, big_sur:        "33a06ed9a47babbb43d062ec537ca1481d374584d82caf13aeffac0315708c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44646f4c6e36b0412c431c2a26f57ac5c25722193d4d20063148683ac24fa73c"
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