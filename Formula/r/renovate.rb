class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.12.0.tgz"
  sha256 "0d0469bf8787cc3a0c77517be297d2fd08f6ff17eb781448566f5b13e1dd6ed7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9401e944e6328375a34f556d4f2fa9577bf6267612635274f6f999c8a07bc13a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9ed3bfd801b17e07ce056f304492a30d5f9dbcac61a9d1c401265bcdc05c722"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7e4e59326730a66dfe40f82a7f6569d89002c7b067059753030718e3bf4e0e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a5d65470d8b00dbfad64cd44a84e930c195c4b2bc8160b1c1f230a06745a5ec"
    sha256 cellar: :any_skip_relocation, ventura:       "dd6a37a36da307fd6343e9209122134282853ffd74c2175db05513364ddc1a00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a17cad422369baea856f961e7ae341e07976f300070df41af335a56e3088755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "809101f876a8f0d73d2559d642a53f7ed41b91fff518fe16a28ae28141e4da7c"
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