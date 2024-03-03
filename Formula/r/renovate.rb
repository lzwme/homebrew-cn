require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.224.0.tgz"
  sha256 "e1c1e1dc4408eb65d6e410ef115dae2151075bcc4723efc0502283ec7612d2f2"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3670215d293d8f8a9989d529f95f02f843944d80c7997930e874690bfeca9c79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0f6493320bb33d901557090ce3aa634f279c1c3b77da73417ab0934d1b29398"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a82032f8fa300a83c5ca4dc1c189db08b499077398e49ab7e876bceb7a5ef57c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f5dd418187830d261a22312525fec34794a69441d9c481e0b543ab177e9bae3"
    sha256 cellar: :any_skip_relocation, ventura:        "8f6bc05fb5dc8e46af06a968dd90155d0f7ced0e85144ee250aafb989baeba1d"
    sha256 cellar: :any_skip_relocation, monterey:       "f2d7de46187921c92be1edb55949131c6f746354a6b58dc91cfb7b95461f0439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43576b9383e80c871887c7d7ed8fe8a2503c001b6464c4606e07186df4b5c79a"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end