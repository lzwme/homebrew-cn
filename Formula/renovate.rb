require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.133.0.tgz"
  sha256 "0b5edce3648cfd3fbcba3b4a60aa31ba9bcdfb76a923645b4c53f32c0273d6c2"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b87d755f3ae5df34afc5dfce5a4c26a699c8ce2dceb8fdc8ea6a0c36d4016c30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "569829dde358e2587611f74ae6da7bbaae06c68af2511579a0f6ba47a499b0b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e592e83e0239a481bffcfcb9f104e9ddb44f4ef79d90a64f4272882ea9edb58"
    sha256 cellar: :any_skip_relocation, ventura:        "9e92f4695501a312fc9f46e08b830b061afacf456f1682649116cdd289805f91"
    sha256 cellar: :any_skip_relocation, monterey:       "8b611308ca19f2207afcc80745f4357d419b39307fa6e40b6eec2f5e4b078c70"
    sha256 cellar: :any_skip_relocation, big_sur:        "bac217d9f8f0c62b0cd7d1307e2fadd6752afb93a54193e7705d75fff44a13af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feafde8161c39a581c17d2908125cae002106232235a129a00ca61992e68c6bb"
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