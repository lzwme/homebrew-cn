class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://ghfast.top/https://github.com/devspace-sh/devspace/archive/refs/tags/v6.3.16.tar.gz"
  sha256 "25e9fff0e6084584671644a3ac3a328123225add6a5fc5d2fb8631104bd88de9"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c116edc5d7cf3258291649ee5b36c85fc43a3943527b565d7f44adf56a429df4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac6e5a90ac1cacddff4244861cc12a79f7bfa13740abb3781138a4e995931430"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f91b89019db95e9bff40215580d41fedc9c89a5dee3b0ddf2f40d63963dbdc33"
    sha256 cellar: :any_skip_relocation, sonoma:        "53ab46bdd26d8297417833a10d713c1ac6b6433faabea560a411a552afe67468"
    sha256 cellar: :any_skip_relocation, ventura:       "ce9b67d35bdd177ed46dc8e32510c533281b878b0673f710746f44ddcaf792de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcf4bd2c0eb732d42ed5673d53cb63cd3eba6cf8aeed5e6855898070ae1893c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f8f5a6db01973d17e345c0b8a8356fce22c20f7006a9a91f6eaf54344842475"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{tap.user} -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"devspace", "completion")
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")

    assert_match version.to_s, shell_output("#{bin}/devspace version")
  end
end