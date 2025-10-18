class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.51.tar.gz"
  sha256 "6c8a223b40bb53c14ec10c35ccc1713d5307489234dbfeda2029f7658df493f2"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15a399ddae186ca29f5850b83d1c48bd5cd01afacbae17a3286fae362d636e9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15a399ddae186ca29f5850b83d1c48bd5cd01afacbae17a3286fae362d636e9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15a399ddae186ca29f5850b83d1c48bd5cd01afacbae17a3286fae362d636e9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd83686b350bd25d1e22cb33a96cec09debc82db7b56c373e868f626ce0d552e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d975041c64b356717f0e40e9e8b25bb2ab44e7a311c93fa9de83d2a554ea347e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "977cd11353c8945c2db1efa15cb27e350cd40f2e62812186d5c576e024bd8428"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end