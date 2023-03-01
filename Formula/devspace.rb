class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.3.0",
      revision: "358eb5888c16c83c3142d86c114466b4d703c232"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73e2b56c69b8953f9d9825dcf6b2b3d7bff25404eb994f25e1d1043840fbc579"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ad2ba4c9a2dcbcea1465b639654cce8b82cd66472192c1a6f3c0a11e7052ad3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef3820e5b6f16b94044a4f7bbddd20a05636b9bd5eaa6efeb2924cc998f502e4"
    sha256 cellar: :any_skip_relocation, ventura:        "0c5947bd91b600e3db987fbc8f3a6b50f4a1416978ce6773afc3a55045aabd34"
    sha256 cellar: :any_skip_relocation, monterey:       "cf0fa870523cc3ad11bebbadc9789c27f026ebac77733d1ef92586344a72c667"
    sha256 cellar: :any_skip_relocation, big_sur:        "46baedcb964761c1d542e244a87220fe79f7746a79fdc2e71b186b9873e04de4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d609099123dd40e7002bbcd45bbb0f0015bb7e80c8fbc0419ee485f89905ce08"
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