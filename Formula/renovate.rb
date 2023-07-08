require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.5.0.tgz"
  sha256 "ab1b89a0bcf4784de069c7bfab31c664ab156c940edfb64400a4646d9fc4d37e"
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
    sha256                               arm64_ventura:  "53d37edd33bc989e360b44ba6cd2a969d78c41238e123928802cc06b53b19039"
    sha256                               arm64_monterey: "c6eade24c1231e1cce88ceeae9287ca0e29f6962f6ca3b6f3b59aa85b7dbe516"
    sha256                               arm64_big_sur:  "fe5c53ab1c8224ab36c2911f69c5cda82111dd5c996cb82ef053ee89f3ca7cbe"
    sha256 cellar: :any_skip_relocation, ventura:        "c922d690070665e39995625e8289a01150134fbeb79468d5afb205e32ebe5e12"
    sha256 cellar: :any_skip_relocation, monterey:       "4071cf50cf71dc0820e4f6a6bf044fb4e07029ff0ebb99de1f4d615bd4220807"
    sha256 cellar: :any_skip_relocation, big_sur:        "46fdada07c9fdb1ac251adc6cad8762ba1408d072f48afa6eccba0f688c2f9c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21923c585314e91dbd159d06fa8545c48cb312f244e10994e264d654dffb6cfc"
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