class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.61.0.tgz"
  sha256 "aec08793ba3eed3327c036898065b0ef0e2e22189c681ab8219a3601ea22ee09"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29225ea6186bd632e3ed739e0357d2b35a83c917057554b907c7531fd0b5c1a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e63612dfda8d3c859358c7da5dd904f3e08d3b3803f5106d1d7fba232db099a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96440796c1d42d68604e40e5dadf8d0ec03ea3cd1fd5d1acf5f69d6bc5bd9a65"
    sha256 cellar: :any_skip_relocation, sonoma:        "59fcbd6a7e0de63bbae349e11dca6b3c402998f415466842633cab40bf153e60"
    sha256 cellar: :any_skip_relocation, ventura:       "6995b7aee79496adb0a0b6acf6b47379e26c87930e4b220ce758ce394dfd0fba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fff19a348488c37da47ad286d1be06438bad34979030330ce94f64e968827108"
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