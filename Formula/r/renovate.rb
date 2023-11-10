require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.53.0.tgz"
  sha256 "4b69f43ed6c373f911b929d5a4a87b474793ec7bf7376aaac08bad02e91ae2fc"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c11aaac3a2ec1256060945ceffadfa54cda15b1e191c7735ac6f9d4101178f9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "946097aecdb67cc329b08abe9bcbeccd76ad46db4af6b47f327e309454e49975"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d57496775546c8fe50208a3eaccd66b1ad55e8a4cf6fda890c3e36289937963"
    sha256 cellar: :any_skip_relocation, sonoma:         "d32ecad1e2f6bda12060c687ea7423cef6fa34aecd0515a881b370d721e39f10"
    sha256 cellar: :any_skip_relocation, ventura:        "7068b47a0ba7aa956cf92396702de9a18dd0e8edb98f16a4d4b346e9c24be42b"
    sha256 cellar: :any_skip_relocation, monterey:       "8e90e28f75394e63735bfc0f093c18b8a7f99b2909cb3714604b508476ceaa5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a51613b6d09eaa0776ba2314cc957f58c97b7866bcfab63cacbc337c94780839"
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