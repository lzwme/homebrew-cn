class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.248.0.tgz"
  sha256 "2895d5fa17543e813e1c9051f41cd8c1bd6f38538ce24909b11d63caec7c4ff2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f41c91554761baf625b974f560dfcb18e23c268e756c6403752d90bc92181716"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fd8244d69c6eec055f1e92ad01d7cd73da6fcce568ae47fdecb3aae56594b17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26f1ceb010bc0904e3e21332b6c9f59a3696e77a2eb6df0575e9775bc4de50e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c17c4ac8161b7a3a40674ad58461f721df1155dba210312d0e818d0de4af9e1"
    sha256 cellar: :any_skip_relocation, ventura:       "84bb44d33ba9d90552f4ab55d6790dee6d4f4490b2c1a12e89535906ba1db86c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6eba77d7228ec9cfd4ab5800010e072d762c0b42f150097b0abc0cb16eced572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dbafeb97bb9a33b391fdcdcb091288a5f14f5988e1546683eb3c030bb268780"
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