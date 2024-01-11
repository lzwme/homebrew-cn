class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.31.4",
      revision: "356c56138e10af4e2ba5f297401dc6089811ce4c"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a1dd6ba562772311f6d1c10e9036dec50ebeb7fdd8ccc00caf86a99d91b42b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bd6823174219e01c9c03982d5f80c29a44cd6f1004d17568e359998a540280f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adb643c67a9d0831c200e002cabe7e181fd3ca3d4d97df64a1784822eee0d492"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2a222f0bfb87eb8208c456840e3d6d8ceca6fd545b4648b68d749a41f023826"
    sha256 cellar: :any_skip_relocation, ventura:        "4e7ef49138e6480b15ecfc42872e91559aae4d44c701adb18e8189e337881429"
    sha256 cellar: :any_skip_relocation, monterey:       "415d74d38ca56a67be15094ba7f77728903ea1bfad370a9c1b06b00687af7707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72861bcf8b1d5ff26e1f1ac29ac07890d153a8e3bdf9bcca893b6a8c58d46ef5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comderailedk9scmd.version=#{version}
      -X github.comderailedk9scmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}k9s --help")
  end
end