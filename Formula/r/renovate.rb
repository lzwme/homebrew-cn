class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.60.0.tgz"
  sha256 "4cc997d7496513780eec56e1a4ad921ed0f32f60147bc14a8fd66e217039fcea"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b05de741ef3406398d2b6ade05670ecfe5f1caebe744563d11c441ceb61c6ef6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b2911250f9b3f1883199a76b9dd5d1079ce62455050b8e581c41b4faeb11e40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1946c698f7f8e057371090aee92e0a370d64111a9805e61c90be861ac2c776be"
    sha256 cellar: :any_skip_relocation, sonoma:        "468c2a427db1268f2ebd65a51702f9448634d3f00d9eb5587ca807ce324ab9b6"
    sha256 cellar: :any_skip_relocation, ventura:       "55703a6667adf734a0db70d993da09781a3103e29e7be00b572cb0805b495cca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a89e1317fcac192470b11de2fa5f0b38df091c2f6b02ee20a0718fed5a627b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7919491f063cda19fb9f6ce68a2e9683fafcbaacffff73d7bd91e721992c56b4"
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