class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.10.15",
      revision: "d6ed17ccca84f8db93693f541894c675eef21f16"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c78c30ff496d5134c7df32883e81aa6d7e2c8518757d71938ef58cb03f69f5ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c46582be51128fb70ca2897a4aef387142b7894864b12c6de85eacc3120dac4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "972d8f65ab5f253a3c4448d09071547ba2602d1b2a46653ce48f23cb5fbd1bc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2186b092412891a8c6b4c5ab77a91a370ff5b422fab49bd24b66cf29e223407"
    sha256 cellar: :any_skip_relocation, ventura:        "969decb9c8e6a0ef5ef59e6b85e5829174ab99b88f6e994a116bf05a46dd86ad"
    sha256 cellar: :any_skip_relocation, monterey:       "f056b150c42b72f44400d29f352eed0ee62823909c4dbf6c975b38aa55135f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b827c6ea8eae1cef35550ffdad2c925e2baa0a14a1c6fb22cc30fa01b1f7e7fd"
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