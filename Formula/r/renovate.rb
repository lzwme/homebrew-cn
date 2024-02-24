require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.212.0.tgz"
  sha256 "30a939475a8973883abf18f6e0469ad4ed242c65d198a114b77a379ccf19c2c8"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "829da105a4e467b21ee5de01490071d04758a565e3632ef04e9ae9675437b2a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecbddbc7ae1d58707cb275734e3287e421422bc72683a5d1e636017b8ebd2f7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1cfb7c7b631daa27d8b8ddc28d5b99dd03f86d52b7df9c439512148de416e35"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c6b6d97915470003a3a3bb4f54654fca6e2e29accbb44695804899845c7a54e"
    sha256 cellar: :any_skip_relocation, ventura:        "8bda340ad8232cbde49bfaa8d9ef0b855e83ab438d4f40960899324dcdd672fa"
    sha256 cellar: :any_skip_relocation, monterey:       "d4538cd7a58318f1f24e8d70946cda9e3c49cea566048fa7e8737258b27d56ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da1cb95da6ac2798f3827054393a163566be32681bcc19574f42d887e202411d"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end