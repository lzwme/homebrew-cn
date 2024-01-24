require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.148.0.tgz"
  sha256 "9e057c6076e3a967b9ed4b0b83e5d689c4f32c4bc4e56c72dc7b3b8d48fe02eb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "145ccdcc6e403de0903842ee8aa1d807545819543cc9056169b3d4e87ac1ecb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7e8c3855aa4de495ccf8605f37a5d33577c594f09f1def27784bb6dc7d02237"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e9ccd243ea6fb7598601e1a78a15907ae60b2cdaa8f91a5e5b1fee96d866b40"
    sha256 cellar: :any_skip_relocation, sonoma:         "31dd12babe38ee73210512048829609887ea234e2ff98dc53a261bcc4954e9f9"
    sha256 cellar: :any_skip_relocation, ventura:        "ca07cf67b64486745e256406711bc808d5f311c6afd76577f330b921ab4d6a2a"
    sha256 cellar: :any_skip_relocation, monterey:       "a0fe049f79b5adf51ce0b7656d133d7469a96123ce7158ac97907317f63ab836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "485d44fe04eef6ecd0407df9f54d2bcae56d03253902fdfd8cb8f580e6efd234"
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