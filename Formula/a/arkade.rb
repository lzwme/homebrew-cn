class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https:blog.alexellis.iokubernetes-marketplace-two-year-update"
  url "https:github.comalexellisarkadearchiverefstags0.11.26.tar.gz"
  sha256 "ee57bcd304ff091350683ddd377160814fd3133b397f625a45053fab46894c21"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e01bf7c786c22ed33898d13b8e4ad4ff529a42d8333170f3be5d23c16ae3106c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e01bf7c786c22ed33898d13b8e4ad4ff529a42d8333170f3be5d23c16ae3106c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e01bf7c786c22ed33898d13b8e4ad4ff529a42d8333170f3be5d23c16ae3106c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4018176909bd9bff9267c87221df26f81147e83e00950513cd04d66155ff8968"
    sha256 cellar: :any_skip_relocation, ventura:       "4018176909bd9bff9267c87221df26f81147e83e00950513cd04d66155ff8968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65b055a98c3384245fbd68335e2e0027c834cb3d6fddb0c77ade131912380b89"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comalexellisarkadepkg.Version=#{version}
      -X github.comalexellisarkadepkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin"arkade info openfaas")
  end
end