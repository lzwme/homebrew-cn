class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://launchdarkly.com"
  url "https://ghfast.top/https://github.com/launchdarkly/ld-find-code-refs/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "99e916d4001017336e64ba1830375afac0b378d55388ba804372c48e53e92dca"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ca23342dafb61bceda367829395b386db5790d0a597c73a38815fa2d6367def"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ca23342dafb61bceda367829395b386db5790d0a597c73a38815fa2d6367def"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ca23342dafb61bceda367829395b386db5790d0a597c73a38815fa2d6367def"
    sha256 cellar: :any_skip_relocation, sonoma:        "d477de8097483aa35a5ffbb9677138cba077d5b6c12bc740bbb838620c18a801"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c76e698bd3eaefb0b2b7cda37c1d740f241ea45f67576c2800466dff464d3fc0"
    sha256 cellar: :any,                 x86_64_linux:  "a75318997f866522285588bc1a730a900e92e7fee20559eb074f45b113e34d32"
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