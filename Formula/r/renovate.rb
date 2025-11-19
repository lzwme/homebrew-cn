class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.14.0.tgz"
  sha256 "52f8adfee388ed9638fcb42894e4e19a2276ad269b55ebaba86491e1a392f624"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd49b939b8b3ba3850b976444608f8997db605cf2e72acf89453463b32677309"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd2f9745a8d78d80c4cb8cbd5752926b8c53b21d432d2221e92792e2f477925f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eee872f28c0d829a7da4cd7fed825a3c70c59a7ae4b88b0be292c534f157341f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4048f5b77e826bac80462b4bf93a4941bd10492dac16bc1b60ad80a8717b62b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3100d6d1da787ca00ae82b8c4f578baa8c91de2533198ee3903bcc119799979a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35f6f3780c11a0417e3f282e0345ed4860950a18a22ec60ad4371ac7cf218d07"
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