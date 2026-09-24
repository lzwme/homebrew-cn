class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://launchdarkly.com"
  url "https://ghfast.top/https://github.com/launchdarkly/ld-find-code-refs/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "df46870ab01a85a4872b5204be281477042afcd8377710a04e76eb52fb5fa658"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76b58bf375c01c888d4847501fd020c89570e6430f2356476d378e9725649fde"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76b58bf375c01c888d4847501fd020c89570e6430f2356476d378e9725649fde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76b58bf375c01c888d4847501fd020c89570e6430f2356476d378e9725649fde"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2a1c26ab7c3efdc8d6fdc799933e501cef1341267edd704f4f6f8622a35a55e7"
    sha256 cellar: :any,                 x86_64_linux:      "495450f33b2e654c644c105e59a8d4227c91fcd4d5f3a9b9cc1af603cab6d62e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/ld-find-code-refs"

    generate_completions_from_executable(bin/"ld-find-code-refs", shell_parameter_format: :cobra)
  end

  test do
    system "git", "init"
    (testpath/"README").write "Testing"
    (testpath/".gitignore").write "Library"
    system "git", "add", "README", ".gitignore"
    system "git", "commit", "-m", "Initial commit"

    assert_match "could not retrieve flag key",
      shell_output("#{bin}/ld-find-code-refs --dryRun \
                   --ignoreServiceErrors -t=xx -p=test -r=test -d=. 2>&1", 1)
  end
end