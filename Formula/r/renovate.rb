class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.32.0.tgz"
  sha256 "7a19cbed3e9c83d7709592d9180ac8de4290b92815d82fefae7e6ae3bbda333d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb507ac21605754aa8bd9911181d093538db6ca7c152f13ec0c43e487650f955"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbd97832f8721595e56f07878b73944fc87fa4ba0c542812904270b98f75414f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b9080400d195e72f518df6b31ce56ef358327d8d4a80f1d4e410e70305227fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4cbedcad0efa6dcc0bf5fb67e5194607e36c702789b9f0023d0bb04007c8a24"
    sha256 cellar: :any_skip_relocation, ventura:       "d2081fab1448c3f32a529a41649d79a9b5b809303691250572e7472387dcdf2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01dee23f2005ff1abda309eafec63560bea7e9e2619ff1aa7ae4a67cecd73db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "760b7c16672e58d5a95516f57586489897dffbec4ee0bdde50feb7621b8eb62c"
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