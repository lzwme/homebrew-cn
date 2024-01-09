class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https:github.comlaunchdarklyld-find-code-refs"
  url "https:github.comlaunchdarklyld-find-code-refsarchiverefstagsv2.11.5.tar.gz"
  sha256 "400267f07fdda975d41b48d9541bbc7b8049aa535adce0384bf06bdf3d85dc28"
  license "Apache-2.0"
  head "https:github.comlaunchdarklyld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54a890ed7d73a80eed0f9854c4fedbd6d09851edd25b623818bf82566be7ff10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fdf4b321c0bc730e43876fba591e19d565bd334a935d56243ab35e0e896ae80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9694ace8b5fa3bb79667396859a7853305084156768f456c5b1ed7e334e5430"
    sha256 cellar: :any_skip_relocation, sonoma:         "be2c21acbf214cc559e60a97e8a760d4ce1699931a7365b0c28bf725b4191d7e"
    sha256 cellar: :any_skip_relocation, ventura:        "2ce084a3b9c1cc27074297b1f9d9dbab2ff62350950249236c510dbe1a4a623f"
    sha256 cellar: :any_skip_relocation, monterey:       "fe6afa708e973ce599401d482fd1bc358aa34134f8d9954e907d3db83d121ae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "549be26f0c4ea299f85816c5aa7a68437678b0967a0e7eecdc700b16206602fc"
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