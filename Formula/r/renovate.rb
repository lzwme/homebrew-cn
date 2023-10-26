require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.33.0.tgz"
  sha256 "cdc933849e38daf7c75dfa2839ff849396674e2763206496a7d8031a8712da67"
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
    sha256                               arm64_sonoma:   "09ce409e05d90ccf9a0fe964ce7ff3c266f12a48e377a97048a1c1c6f4b28b22"
    sha256                               arm64_ventura:  "98f067f2dd1a4e3ef8d2f81da90e2b1821e36b829fc232de3265683cce7d691f"
    sha256                               arm64_monterey: "529a7a04e10de9a04845c7d5df206dd8656e2c33637566f53ca00b550635f39b"
    sha256                               sonoma:         "85b8187b0028b5091141d0b40d353e1c9205e65c9f7ffa565cd982a020c31716"
    sha256                               ventura:        "98e1dd5fb933ed2d8a72859eeba53d2f7e102863304597d04e090290a42a644b"
    sha256                               monterey:       "cc60c44fab02dc44cd8bbb297f3a3a4c059f4bc4c127683e43a1c31e5faae736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05d943e9ff9bee97c2b268ab793d45db9e8c234e7982d40136d3f3c2e886eaf1"
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