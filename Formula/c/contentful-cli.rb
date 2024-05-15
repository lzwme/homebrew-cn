require "languagenode"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.3.1.tgz"
  sha256 "002e72f348c6787b97d850d346f97fcab1aac706a1047a5a1bec3af8b16fb7d2"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da3a2317129eaa28c20073dc873aa0b6cd6edbfaad2325b9c968f6b553c8e020"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0190d8dbd0b871cbd24e7a930c9046f5a6e3ad08853a39be44d2d44b3f829ae4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51d8283028adbd87214c58b5578253e1187a08fca0faa561eebe2aabc67f9a8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdbe10bd22baca6e038a1df1f8103b2877f991b3f577647b38f7ce2d7a071301"
    sha256 cellar: :any_skip_relocation, ventura:        "5659a2868c9db7bfcf3f7cb614a2da19f0d330716156cfd5674c04db26dfad77"
    sha256 cellar: :any_skip_relocation, monterey:       "5b7d2882fb80a52e8757aca918662c29f26cd540fc12b4031a276f279398e34f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8e593405f5c04147dcce73df5916b4470cbc08851cdb563678638894151d6fd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end