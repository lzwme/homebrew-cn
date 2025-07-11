class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.30.0.tgz"
  sha256 "9ee6a03769be57f6d3019138a7f588f2f39ad6dbe4204556a3b051bfd4a0e369"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05d97363b31bcde89bbd219169ffc0f1c07eec10fe69326025dcdc841f9279a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "063ac86dc1792f15f7071f945993d326f68b9b1f63d2cf6b55116fd6646ef51b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "268771b782a73ad5c80058190aba62d5c3f83ffd9e7ca16e430b40a2c964b816"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ea9e021836a1368e1ca786ad17ea4ca3ba005bbad455fcd6ee324f15225cd53"
    sha256 cellar: :any_skip_relocation, ventura:       "94ed800f5091c154d92798369b5c67ce54dd61a9d52f05f64ebbd5e625ea5a73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20a8d75b5ac101ebf09ec2b3b960824485818a4a2e06852412d69d2ec24a9cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ee2ab132f6fad2788501fd915d410bc879a325dd49724eb0c01636ee24e689f"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end