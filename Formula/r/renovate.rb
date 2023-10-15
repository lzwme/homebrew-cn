require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.19.0.tgz"
  sha256 "a424ad1f82cbe2a8f7deccf4f3d0351708808f7e5beac47dfe5af6ea98a3e62b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a5afd670bb8a390f1bc4a8f67879ddae97d4636fa5f6d0bd697d5aa2b78a493"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2aa17ec1000b8e93fa665743cb28c05191890c51107ea9786e7bea831d0df43d"
    sha256                               arm64_monterey: "531bc641670683e7a73a7af5bf2e6f83f941e81f083494a376084c32ba1053ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "46d35fcd3267c7382a90b7b1f7943cca4577737ac2afc5d571f8190d9408f313"
    sha256 cellar: :any_skip_relocation, ventura:        "12f0edb4f08c04d6828296a6fb4dba1895bfdb4ff4d200ef8175c1df0651300f"
    sha256 cellar: :any_skip_relocation, monterey:       "23b1a6882a30f6f2cb28e93a5c21a603ca696aa24421c65e376fee52c16030bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85bc79dd7aa7a663116821e6ffec4ffec150379f44fc3f8d7cca14e690190aec"
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