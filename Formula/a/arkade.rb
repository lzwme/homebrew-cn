class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https:blog.alexellis.iokubernetes-marketplace-two-year-update"
  url "https:github.comalexellisarkadearchiverefstags0.11.15.tar.gz"
  sha256 "d97012206ab8901d020167a5f39b6638a3b1be0f5368b74061582eee7a50c392"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f1f09b63cb700b538a126d04ea5e2550fc27e92cef09e3238b37993280b5923"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85dda5f815b3b33419b872a9dddcbb0963b5607e60ad5fdeee439739ba032fce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c377e2b8ca4659208a107a89eb59fb6fbf2c683909d6fe59670f7f0d84f083f"
    sha256 cellar: :any_skip_relocation, sonoma:         "59fe49fe91873bf1bbaca1c60d3f33f6c15fa0ac612267dccb762a0120e07055"
    sha256 cellar: :any_skip_relocation, ventura:        "1e1e677bef1c143907a1b67753d3c9ca457c37563685859b37da5cd1a0d86573"
    sha256 cellar: :any_skip_relocation, monterey:       "4f60ce121ba08f6d900667a7315d190964c8cb79b16de5155b3a8ecfdf10cd3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "251a033e9367a844eef407bdcfcb74291d043deccdb6e21126a0dc412edee834"
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