class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.0.0.tgz"
  sha256 "8e5116c828ede7f5f1edabafb5897f9534605237e8e4125463b4c853bfa6015b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56a8ed4207e5bdee7df9b60c0ef6fa5a3252e5d453c178ce6c3064c5d75062ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a18ae89a368b3c3055f20cf99f65a8637d6dd3e0b03b464cc8a9648cd334b159"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebd01eb706acc9e8bee88315634eb03bc489eb25e722589ab944d96610012168"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed0218c0bc951a3786dbde0006e2e8d0852eda0b730f93f4f6a9b4d01d69ee58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aa3882e73dddda409b21bbdd4646d74b9dee22bc0b33431318bc04026eab339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "212c634412bd6ffc9f792431be46dce560b599e56786efb1c60341f6e65e576b"
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