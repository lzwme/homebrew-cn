require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.218.0.tgz"
  sha256 "0fe07740ff924f018ddfb3db06f5f3cd19bc9430da7466b2e9090cae97f434e0"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e801fa8595c682e68a29e060d941d0627e6155450dffcc318e5b5dbab5f0619"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6319bad1b1ba92b43e4f3577bd8a29dddefb2a155b7cda2cee4d5e5ce3f226e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9e5064622a8c277c20c054edac906b1b028a14d8d2952aeab04427954300230"
    sha256 cellar: :any_skip_relocation, sonoma:         "83ca9ca663a29252df85585289a4551f462b5f8c664d6040224e1b9abb35bc96"
    sha256 cellar: :any_skip_relocation, ventura:        "394181778686a06e820df8dbca813edec3e23fd3f5fcc5734cfef8b7ed758d1d"
    sha256 cellar: :any_skip_relocation, monterey:       "3f8292d2718a004df59cb112f290f92ebff8848cadb92f0fe8fbf354eb3681c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69654d006c6535b049595c2813ce372d3b53f770c91a41894f00f699f18164d9"
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