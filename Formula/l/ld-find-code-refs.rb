class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://ghproxy.com/https://github.com/launchdarkly/ld-find-code-refs/archive/v2.11.0.tar.gz"
  sha256 "093c8b576ec0b36dc71a845bec414a7295cb85ea7bc3b32a3d48ec3484f66836"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e35610448ae78585577ff0d76ca7387ffffbdfb1a9ea89e92544280a1fedbb45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e35610448ae78585577ff0d76ca7387ffffbdfb1a9ea89e92544280a1fedbb45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e35610448ae78585577ff0d76ca7387ffffbdfb1a9ea89e92544280a1fedbb45"
    sha256 cellar: :any_skip_relocation, ventura:        "379a0fef78010ac91f5fb837de91c40ef7a676878e217ee79510195f4770dce7"
    sha256 cellar: :any_skip_relocation, monterey:       "379a0fef78010ac91f5fb837de91c40ef7a676878e217ee79510195f4770dce7"
    sha256 cellar: :any_skip_relocation, big_sur:        "379a0fef78010ac91f5fb837de91c40ef7a676878e217ee79510195f4770dce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43fb5f52cd55aed8c1f434d5b8412382ab0ea3bdb65333872a7ea773367d05eb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ld-find-code-refs"

    generate_completions_from_executable(bin/"ld-find-code-refs", "completion")
  end

  test do
    system "git", "init"
    (testpath/"README").write "Testing"
    (testpath/".gitignore").write "Library"
    system "git", "add", "README", ".gitignore"
    system "git", "commit", "-m", "Initial commit"

    assert_match "could not retrieve flag key",
      shell_output(bin/"ld-find-code-refs --dryRun " \
                       "--ignoreServiceErrors -t=xx -p=test -r=test -d=. 2>&1", 1)
  end
end