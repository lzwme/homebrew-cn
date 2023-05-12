class Access < Formula
  desc "Easiest way to request and grant access without leaving your terminal"
  homepage "https://indent.com"
  url "https://github.com/indentapis/access.git",
      tag:      "v0.10.11",
      revision: "dd71b8b3d12e86c3d87dd78f10873469d97dc66c"
  license "Apache-2.0"
  head "https://github.com/indentapis/access.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae9a11f6e119aa508d2b526b6b539b871f45c852075bfe6c1e92d24374b5da70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae9a11f6e119aa508d2b526b6b539b871f45c852075bfe6c1e92d24374b5da70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae9a11f6e119aa508d2b526b6b539b871f45c852075bfe6c1e92d24374b5da70"
    sha256 cellar: :any_skip_relocation, ventura:        "3b051721265cc9b779171af4620b1e74208cd95c62453407def25e3c79fc6c41"
    sha256 cellar: :any_skip_relocation, monterey:       "3b051721265cc9b779171af4620b1e74208cd95c62453407def25e3c79fc6c41"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b051721265cc9b779171af4620b1e74208cd95c62453407def25e3c79fc6c41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cef331bbd2b8e9b6d2551926c041997ed12b0324c9495223c624190c4431aa2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.GitVersion=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/access"

    # Install shell completions
    generate_completions_from_executable(bin/"access", "completion")
  end

  test do
    test_file = testpath/"access.yaml"
    touch test_file
    system bin/"access", "config", "set", "space", "some-space"
    assert_equal "space: some-space", test_file.read.strip
  end
end