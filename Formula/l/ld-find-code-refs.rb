class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https:github.comlaunchdarklyld-find-code-refs"
  url "https:github.comlaunchdarklyld-find-code-refsarchiverefstagsv2.11.7.tar.gz"
  sha256 "9b5ad98d19be583f8cd06c0b5293c742de3c95e2df3dcd18d929153398ead6f1"
  license "Apache-2.0"
  head "https:github.comlaunchdarklyld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "161be459895d40dfc1dc35c54e137b67676bd7f33b857b9d84f81ecada4f3d98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f7912cbae30e8c6cc3d2d5d584984ea9132ee8f46b8d7f2aa630a163da5ff94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "423ab16644c9fa6f9678c3a072f843c506c84e2903a7169b2ede9326df132b6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4de74c92e1a2d6a547d78982bcdfbdda4c79e9ab564c18d3011ce8974cc353a0"
    sha256 cellar: :any_skip_relocation, ventura:        "ffa46b057a90274d255a80e026b7d82aef82a5e83d125ed5aae84f6ad358d0ab"
    sha256 cellar: :any_skip_relocation, monterey:       "ad6127e25b26884c7a2eb7a830ca50295c76ec56497a407fb5f0f80312e14529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "493fd665c488fb12044f3cce21b1eb639fd06f100df49733f7ebab73191738ab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdld-find-code-refs"

    generate_completions_from_executable(bin"ld-find-code-refs", "completion")
  end

  test do
    system "git", "init"
    (testpath"README").write "Testing"
    (testpath".gitignore").write "Library"
    system "git", "add", "README", ".gitignore"
    system "git", "commit", "-m", "Initial commit"

    assert_match "could not retrieve flag key",
      shell_output(bin"ld-find-code-refs --dryRun " \
                       "--ignoreServiceErrors -t=xx -p=test -r=test -d=. 2>&1", 1)
  end
end