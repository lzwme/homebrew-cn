class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https:github.comlaunchdarklyld-find-code-refs"
  url "https:github.comlaunchdarklyld-find-code-refsarchiverefstagsv2.11.6.tar.gz"
  sha256 "abf267388b8800cefa17ee4acf5441783d029b743525875abd4fe0f00b97a1e5"
  license "Apache-2.0"
  head "https:github.comlaunchdarklyld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c408db354dd39f0b27f904fe8611a69eb5597a8d45fcdd5e45c7c9a785ce1f02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d80c0993cccd2ffb365950eb01c527045eab9563383098d34e7df3c2f443d7b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5383509d7a5fef4cc2a755ba9e91ae59b364bcd54fe0ab9261554ebb83f395cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "378547353ccb2f656d9e8b28d53085302efbce27f5e065b2bfca62e1aca9aa74"
    sha256 cellar: :any_skip_relocation, ventura:        "1d73f048dfa11c9fd30facec02d7a2b3987a861378c4f5f19741cdaa2341fef9"
    sha256 cellar: :any_skip_relocation, monterey:       "cebc79c57c1894f58fdd28a0be8ac268ca0cd2a28f5725fe9bf45e55762a2795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7a014a7172062b2b56cca02b841157e5d99da5057ac91c287120e7884cc5c4a"
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