class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.3.4",
      revision: "419d97eaa442b843f7be4260ad6a0db188759c6d"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfac82e893647b6f51150ee2aa2eda3b58ccf1cd62e66eb1beec6d9391dcdf2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e99f80b7adea8dbe00d1a657017e1f4abf651fca9686473694a58e7d8d10aed8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce1c8f37a33f1a11085a74800e7cfc50b80a7bf2bcac6a7a02a34c2ba9488eb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f42f69234f4a3b1d3776ac08ba4679a56f0b06fbcb544554ef64a2739e3556ef"
    sha256 cellar: :any_skip_relocation, ventura:        "572c6bee15e47c908549f0204ad91073bb189ae4b89b30ddaae07e3c8b3e018e"
    sha256 cellar: :any_skip_relocation, monterey:       "71b051e10c8d2ba2cccf4ead77fef23a43e88c7c785dabec319de3a1ec0cd2a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "224fe0a7856b32b91d9f9127ab01199e2bbfcafc5822c4507e8939eeb253569f"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"devspace", "completion")
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end