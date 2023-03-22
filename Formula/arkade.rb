class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.5",
      revision: "9ef881da4cd2038a33bf07d9d31d37f0397ff359"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9cb8db58092d68805815b86948956852005e864ff92702a44142281c017adf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9cb8db58092d68805815b86948956852005e864ff92702a44142281c017adf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9cb8db58092d68805815b86948956852005e864ff92702a44142281c017adf6"
    sha256 cellar: :any_skip_relocation, ventura:        "644a43eda69309dfe55899c6326e7b6fe9efced0bd598e7f01e432f334afca9d"
    sha256 cellar: :any_skip_relocation, monterey:       "644a43eda69309dfe55899c6326e7b6fe9efced0bd598e7f01e432f334afca9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "644a43eda69309dfe55899c6326e7b6fe9efced0bd598e7f01e432f334afca9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3d1df6666f6c89e782a9b73bfa936a4e7b7c09bf0b02f32b078aaf5b1f6caef"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end