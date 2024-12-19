class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.74.0.tgz"
  sha256 "a9804996f58751b5bf0ea43f831c3e1ca50821b87bd326669d32f355b9f28266"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adcf2eccd119f603ab3a7e9f79b04a0d755f84ec3fd631591ba6817455c64407"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbd845415e4d50d92fb2ae88dfc03dab0e64c5b4859d453d1a51e0a00b8dd0fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fe754adf928fc0c3f37346434a23114e93338aef21978721dbe85c4afb344e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d90ca1372a40a4710392922520657b5dfaa0f8276bf27c166b9171e4167c373"
    sha256 cellar: :any_skip_relocation, ventura:       "24bc36f5e1e22d6ad6eb1e19f3a084119f048407b155c710ec87a2839a7c93f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9b62df831bee41510ad21247f8793256afbc7d836ff175c675754d5f2f93170"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end