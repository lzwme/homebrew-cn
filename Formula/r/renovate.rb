class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.227.0.tgz"
  sha256 "9f9bc36d48e8ca80ab0abf34d788b7b88b744daf869b1bd1911066cc6103da0d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "793424d42708c5ee4b80f0b562b5fd8faf6d6aea3dcdc263e224183bb857506a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4f75bd7d14aba2f2e4f96e7f850fe17940f7a9343a09a4a2053f28f7a5cbe79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5823efd3f5217aaf0dd23b35ca0909423cdd6318600d87ba388944021cb1ca5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e8b2e8fdcf8d6116cdf5e799dca844f1c31565464d18bbaab21c51cc50d51fe"
    sha256 cellar: :any_skip_relocation, ventura:       "eda168fa8579cf81223a165c67334bac9a0b88adad644a1a0c3a71e44235fadc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "547710c3b7ba687eb88d170eb067809b6692971284cf5db879ff8c65b4f6c881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "637e5259572ebce0e0d56b3fd0b5bb12fbccb86a29ceea4485eaaea80c13f9f0"
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