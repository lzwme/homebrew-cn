class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.117.0.tgz"
  sha256 "3bb95190ee4a73d0dacdce5506f77b32cbca0ee9246f2b83b9fc2f0539256814"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dd349141557327d8846874657584963251a0ec5f306de107309e656e3c0be26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d111f4f661215307ab6548fe9865d9ae8292908719b6decf5a0039a6664400c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bb2f270cd296f1c2eec7cad1b748fa7cd85b1b914c41ab39130638e0f6ed783"
    sha256 cellar: :any_skip_relocation, sonoma:        "95bb96903f7f117e2228dd4ee772b2e83fb2a5aae76c77630a64a3f7a8816e6e"
    sha256 cellar: :any_skip_relocation, ventura:       "a6c8a08d09887ed24f8f7e0c2641a103d3d454dc73a3985b07d2ff8f2f67a992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ab8756af7243993cec6e2112899b48f4f5c184ce5181de766b76d1504168e01"
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