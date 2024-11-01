class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.141.0.tgz"
  sha256 "b2f7bf41ccc2894aadecceac683f0268e88c194324a2f7eb5883639a5bdad095"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce48d3c6cd9ed5f8cfe9eccadca533f268afcd89b739dbfb6d959c973c48bbce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16e4307ec53ffabbcb22918fdf2e8eae848fc448ad10e80c76c8a4db89c7b16a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00817c964a68dd947f02b18fefab01e559208ff1c5749372df07c66468522828"
    sha256 cellar: :any_skip_relocation, sonoma:        "42671938e921de37a281468fdc4bd87bae0fee996658f77c6106c2758ae5df28"
    sha256 cellar: :any_skip_relocation, ventura:       "14a2338dd671c3172695a539d220d7d12d312861b88672ed9190ca220ae018a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35274a53c18a7adec4038ae76e83e9d2dd84095e9f89d991eadf3878ccfa5aaf"
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