class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.10.18",
      revision: "84ccd116f8be52022651756fb48f4fa1e51ac129"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b958de408aa59f263f4ad79162940eeac95b0f661285b90915a6c277e0bb95fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e805e905c02a4654dba2d104741d60806bc822fb8292aad66f4793c64665c6d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fecbc0b60a35ee0d2549b3a0ce80a7a3076404a38372ad78142d2d77bae122c"
    sha256 cellar: :any_skip_relocation, sonoma:         "be1b20d68d8630593eacb0d353ec013265eac385d5ff5a51009a007aaefc8232"
    sha256 cellar: :any_skip_relocation, ventura:        "13fb4cfbcc049f11e8ab4a8a0aa84d64fa5d1711d30269c7a0ae2c841b5a28a7"
    sha256 cellar: :any_skip_relocation, monterey:       "b96f1a5a325c182ceb83dbb49635e4de98db8a47054398d1ad4dd0adb650a1de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea079e65c4a7bf6ae5e06015a27e090968e87b98e8454b56733599054569b340"
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