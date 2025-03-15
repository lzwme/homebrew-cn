class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.202.0.tgz"
  sha256 "6c8015ae2979823fb03d2f8231ed0926756022b55c07737e510bdc3dd8847f33"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dab6f7386ef826d87c3cc3f0e60cbb54d10e66fc5659ddc34531cd6e451335cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d5e8c7cfb77a00e46cf56cb5bc6247b8306e5db90a3773e3a4772d85cf7a317"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5414e3e31debaa5dca1d69fc6d719c7182ffa2e2958bb92641c1578bbd88a2ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "d46d08dedcd5423849bd23e2aabaa85a0f20da2edc28bbaa28a1e5edcfe22d86"
    sha256 cellar: :any_skip_relocation, ventura:       "4ae2fd1fd3a22ca5fb279204bfa0529e5213466faefca27ce01d7f046109176c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "905f7c3c19d40bae56088a34dc9a653a6a4cff7419795a4f4501b44d1fcbad34"
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