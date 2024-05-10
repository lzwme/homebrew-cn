require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.353.0.tgz"
  sha256 "fa324fe6cae75e9c395b796d398279d8d255f5a8631a85a311d6fbfce43bb552"
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
    sha256                               arm64_sonoma:   "03825204182f16c8a198fac729c6ebba014940bb75e80edb14732c4fd0cf994e"
    sha256                               arm64_ventura:  "85998c7f8f61efe934fd036155bd4abbba0a1cb17969db0018e4536ccc1aeaee"
    sha256                               arm64_monterey: "9d0c47717621860aa9d9c5c78dce919da7717581c2d6c3f4f27f2266467ed2f1"
    sha256                               sonoma:         "87db9cfb4cfd5e931ecc70ad4c6c175b5d7aa36aff46dddd6b5627a72c46c306"
    sha256                               ventura:        "385f523ffd56fcb86940a0e4e47750bc785b36522d341e1257b30ac2c2a2db14"
    sha256                               monterey:       "83cfc899b34137049336a8669865024a5185bc5c1bc179a414b646b8cc6e6656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccbd6405f55f8c590857925fd9144e7119b3a892873490ceb5d566922530883d"
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