require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.27.0.tgz"
  sha256 "5b6d168585d25a6662b5b74871a67694feb31c6af01ef99d04766cdbb26ff4a6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b457f5ea4ef2d937d3c51d313d877f0480442d2de69510291fae19dc48f20c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84bcf610da7a801fe83941f857b82be5fd7f07db966507e3d19a74da8175cf6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acb5df6ea9c919953c557c9951729091b7069075d65cebd09d87397f63015e47"
    sha256 cellar: :any_skip_relocation, sonoma:         "12b2daafea9bd9a5d8a2e47269cc35f81fb23c9c793381d15e794d286127b727"
    sha256 cellar: :any_skip_relocation, ventura:        "bfa166178d561960248b29688aee92ae044672b54c3224186b4ba0d98e79839f"
    sha256 cellar: :any_skip_relocation, monterey:       "7cfe39014e0f094c725732624c0fac7b53a22c00009ba750c248a211e68f457a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c865b0899603b58ecbf0e68e3e07874b9456b12e13f934242d975c1aa3152381"
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