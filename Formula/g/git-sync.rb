class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https:github.comkubernetesgit-sync#readme"
  url "https:github.comkubernetesgit-syncarchiverefstagsv4.2.0.tar.gz"
  sha256 "d9f0147f871840cef9dd78c159c374f7b81651bdbfe8f40c6854e1042dfb75f6"
  license "Apache-2.0"
  head "https:github.comkubernetesgit-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8397034cff8794df87a26b13842fee59824f2e973dce0886fbea6efa0d7b2108"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70569c3e566f0246ab3bd0cc8b2660f74e7ad1892035f2a26de2060e55def0ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54f53cf9b39d58b14a3a34f3c9e84a3e81a49e01027fc9399f0180d942a112f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc19998409e148efbe0a21352358eac12a6380dfc98c362e409ddef5f2ad5034"
    sha256 cellar: :any_skip_relocation, ventura:        "0aae819cb5248f7887e97904f17a33398a81bcfe7e9dd159bc2bf2b43071c950"
    sha256 cellar: :any_skip_relocation, monterey:       "ee0a6d98d7ed5414b39da1d84d67db03fc80e6400cd5d9bf8e9e868c0b517a54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afda1b99106ee4b8ce9a4cc10581d333b768e9be9aac9b4e9583b1dc6c2bd388"
  end

  depends_on "go" => :build

  depends_on "coreutils"

  conflicts_with "git-extras", because: "both install `git-sync` binaries"

  def install
    ldflags = %W[
      -s -w
      -X k8s.iogit-syncpkgversion.VERSION=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    expected_output = "Could not read from remote repository"
    assert_match expected_output, shell_output("#{bin}#{name} --repo=127.0.0.1x --root=tmpx 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}#{name} --version")
  end
end