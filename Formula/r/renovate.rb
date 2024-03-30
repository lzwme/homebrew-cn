require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.275.0.tgz"
  sha256 "c80105940d4c502fa6092e55ae761c3e24d0b269ae7083379e2a51f67ec8e17f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "709722820a4f4341f2fa554151b26f011331d6aad8135337e32b45496e1b0e8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "addcc395d1c5e5b6edd232a602bc07ff8557aedca9dc37b4d87a37c16ba716d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05ad03265dfa0ef240da08bc9ec4f40b62171b4cb041ec511d436b11f49379d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "b25422e66d63911df3bc4748abe192b8501b370780d18d52b094bc96c680e0e8"
    sha256 cellar: :any_skip_relocation, ventura:        "036dcc229951a647422804d3c66eb90d95b715427b71ca434e9c741d1eb06bb7"
    sha256 cellar: :any_skip_relocation, monterey:       "a0b243a9daf3bf4b943229337704be4511d43a973f67ce5013ffba71367e6833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b495cfa7e00b6ea0f7509e911462c334da44bee34acaaa777704142031dc6e1c"
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