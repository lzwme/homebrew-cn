class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.82.0.tgz"
  sha256 "e6a7440f6068542186c9817c3f1adc197c26782424e4c498e45775ce0122d7c3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd651e598d23b84e998267750d29941331ad433413bc46006a6f860629b4ad46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf9db6f258a6f0a1b146bdcc1daf7255c547a3b257850fb7c941ec2482c0e35b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95e1bb9fa5db2b0e5c218b41712de6417b5dc3590bcf351ebf41d76ef2f8745c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ca48fcc79aabb9ef0e30b1a0968d83d4871ee343f39a420e45080d260d05305"
    sha256 cellar: :any_skip_relocation, ventura:       "888402efdd70568e0a785c040a030f8e1cadd714d859d7278319d41cd14f9d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b9a13e9215f8f8bbd8e324365c94f1a27a09447145488d1e36ed08781e1ef1c"
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