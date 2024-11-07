class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https:blog.alexellis.iokubernetes-marketplace-two-year-update"
  url "https:github.comalexellisarkadearchiverefstags0.11.31.tar.gz"
  sha256 "66d30f61e9f44cf8b728f888ff251e776bc112101abcb60b5a4562dc76bf89c9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f62b549c155318c8b5727a34c194440673af4882955ab0fa01db5fc85d10dda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f62b549c155318c8b5727a34c194440673af4882955ab0fa01db5fc85d10dda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f62b549c155318c8b5727a34c194440673af4882955ab0fa01db5fc85d10dda"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2ee8a2f7ec47a20ea7d56fcd59ca44955244e01427e5270e6f4b52d519b8b93"
    sha256 cellar: :any_skip_relocation, ventura:       "a2ee8a2f7ec47a20ea7d56fcd59ca44955244e01427e5270e6f4b52d519b8b93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac4fb10c4188c7fdc8f91e28c3df870c2717fa6d6e1b11188e06d1d21ec7145f"
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