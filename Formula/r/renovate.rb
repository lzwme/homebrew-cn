require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.56.0.tgz"
  sha256 "4ac308893d537b51c3d36804d48cac9751e24b7ebf57c83dd7a21abe12295041"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac22d1aa369ce7af5c536a8dbb3c09428982961f32addc4c2a3e05cf25b9eca6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "547490ca85b01630bf39a484d7060d94b40f9437b80eadf6eaa54d97e151f304"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23fab03c0752e740b5f27df62dd0a8ba31879d95407132a69c5854a4f95e6657"
    sha256 cellar: :any_skip_relocation, sonoma:         "55da1cb604f98732caa6895c86bf409ce3b985e2549d5320492ba5aab1a132e9"
    sha256 cellar: :any_skip_relocation, ventura:        "6234f250ce08d72e6e8e7bd991b666e8ae3e60131bfc38bb6122d7bcf71d1a7f"
    sha256 cellar: :any_skip_relocation, monterey:       "0b6aa7ba0db834c1be476ed187cdafdacfcd99715ec971ccd8d9fc3981e6961f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39a6037406f6981a62dd328d633716f9a889472db39132a766e04420390f60d5"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end