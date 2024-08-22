class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv15.2.0.tar.gz"
  sha256 "95af0ac8a4663c2addb79326b10b696d9a9d04753b1f4fc0626ca3937e9f6eaa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c293404dc04a661e5fd1db3cf10e59c4258792b159494e7de455ed3599ea6f19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c293404dc04a661e5fd1db3cf10e59c4258792b159494e7de455ed3599ea6f19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c293404dc04a661e5fd1db3cf10e59c4258792b159494e7de455ed3599ea6f19"
    sha256 cellar: :any_skip_relocation, sonoma:         "33068f27b822a95b45cb68f3c6f1994499e67ea38097b9291693acfea5ac4872"
    sha256 cellar: :any_skip_relocation, ventura:        "33068f27b822a95b45cb68f3c6f1994499e67ea38097b9291693acfea5ac4872"
    sha256 cellar: :any_skip_relocation, monterey:       "33068f27b822a95b45cb68f3c6f1994499e67ea38097b9291693acfea5ac4872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5c8fb3fac4584d43866d6df7361e00c6788b4b0d3f63fe2daaedab80bbf2263"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgit-towngit-townv#{version.major}srccmd.version=v#{version}
      -X github.comgit-towngit-townv#{version.major}srccmd.buildDate=#{time.strftime("%Y%m%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin"git-town", "config"
  end
end