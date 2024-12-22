class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.80.0.tgz"
  sha256 "3d2cd136a618469288a276259d5f50d97961d5af1a936fea539fd574279648ef"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cacbe7ccbb77b4251ff4490ad5dc3688497a73e28c4cea8d59b1c4db558ad97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8733ade932d6602a4ca9dbabb74b44ffd52c851164ed1466417f79a5b7e51e34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b405bfaed489c0fd21c5fd9f9de888af8da15441abc61e4eb886e5e336ded720"
    sha256 cellar: :any_skip_relocation, sonoma:        "c76ad8f76937e7ac6492fc34ba62c23313542362172da032ad93b9fea3893cc7"
    sha256 cellar: :any_skip_relocation, ventura:       "ba1735e369ff59840b390ddfb8e6fa01c39253a181eec7f630628572bb9a0ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9297804fac8ff7b5da40f0f19c9b20bb41073753dfcf0213f4c55009ef11233b"
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