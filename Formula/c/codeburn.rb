class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://codeburn.app/"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.21.tgz"
  sha256 "182055bd9533e1459866bf6dec6a468597f7f5ba63954dbbe1555849a17d6403"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e94dc5caddbded2cf3e5ed6e1a090022cf9e13529234d976125469c692afb7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e94dc5caddbded2cf3e5ed6e1a090022cf9e13529234d976125469c692afb7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e94dc5caddbded2cf3e5ed6e1a090022cf9e13529234d976125469c692afb7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ac9ec86ae74cdb13224578d3c67796a92526f68c18263273c2df23f799f1e78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ac9ec86ae74cdb13224578d3c67796a92526f68c18263273c2df23f799f1e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ac9ec86ae74cdb13224578d3c67796a92526f68c18263273c2df23f799f1e78"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/codeburn report --period today --format json")
    assert_match "\"generated\"", output
    assert_match "\"period\":", output
    assert_match "\"overview\"", output
  end
end