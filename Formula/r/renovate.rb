class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.76.0.tgz"
  sha256 "1af2dc88138fdc5ba5ab227e0f0c778c302ddc8932e1c0db8dee0d67e07c12ad"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d167f7a1c186c70a75a4fba19f10e232426299d15f0fa0186af6037f7bf7e79e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29bc8b28c85b38a739c453ba47de8edda8436d40a8d111d22a2f87893383eafd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48e3f1e0287f3632cf72a250eb8c0f9449c3fc5712941c1af17e3557caf68164"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70d83f8a1cda9ee23e2597b268e7fe86b1fb27daa08da43bd6274ee038288fae"
    sha256 cellar: :any_skip_relocation, sonoma:         "918e4ae9eab1d62497b5c19bddbf8998147222e59361cbe88baed2cb450e1096"
    sha256 cellar: :any_skip_relocation, ventura:        "b8cdca56d0a76f6f72ce833f5e4bb373189b27926ce1cf38923fce213a12fb3e"
    sha256 cellar: :any_skip_relocation, monterey:       "2d8f02e8642f06d8d0cbbbbaa708918a21b228757b3105db6fbf31cffefd1914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ca8200db65805e492e56ce78a74a9812e057d8a6304dc7bf6febd17edab3f1f"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end