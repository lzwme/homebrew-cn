class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.38.0.tgz"
  sha256 "514934e67151189d6125bed155db09c5588d64933f9bd6b63e2f5ecd783c9cbe"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b11f4d183b37e00e854dfe6c61c56d46f17d3ed708968e2124896903250896b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cef1b691f9974eeb32039ccd9379642f93ae775a0fc889b9ac5bd1b657aac9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0dc4d100730ce1ed22404737d0daf8058e1db1543695a04e3b94da910a23e9e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6627f6a9057e12db7d613d301f6d1326bd080d31b2bca3295a7225d4f2416569"
    sha256 cellar: :any_skip_relocation, ventura:       "592809ad617891624efe576362628a30ca07ca9c7037a27199bdd8bf99a6513a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64553222d8dd8f4cda59f4d7838f62716eecbf923b707f7903e5011eab339e0a"
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