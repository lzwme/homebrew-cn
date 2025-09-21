class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.121.0.tgz"
  sha256 "5c45e8b45d6d3ca579cb38fc3f11af28950bbd8673527afe0062847cc812ad00"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f782622ac9d5c512606ec4ab383cb1152d7561b19bc4c20d189d07d97122336"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a5bba49a6ce231676a9d02af299847711e0678b90b70ad361fe0c4a4a702cd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49f233bceb59ce3ff42e8c1bc0bd7f51481d863a6e9724600d78d7df5152fe57"
    sha256 cellar: :any_skip_relocation, sonoma:        "f44b1b85ca40124e3e085dc544841e576bf0d50635ef9e94946e6fff448e5cd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae22ce28cf49898f17c589a4ca15ada6ec99e5f97b2edfb8f56b62ec7b6696e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "049ab5aa5d5326b5d34e7c4731f0e9189a2a1d00724dbaa5827e566e38cb49a4"
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