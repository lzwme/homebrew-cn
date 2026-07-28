class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.114.tar.gz"
  sha256 "f87a943100994da784e70f32c6040cdb990f9eca2ff79c38f1fd44b76d6abfcc"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85387291f448a66a8cbc06588a7f8018e09706a6f57266145e037b54dcebba72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85387291f448a66a8cbc06588a7f8018e09706a6f57266145e037b54dcebba72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85387291f448a66a8cbc06588a7f8018e09706a6f57266145e037b54dcebba72"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c379134581118f85b8671848a00b046642df6079008008dc614972d55920c43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22ab2feea007bba12078bbf3bc91d7f972b253a64ef39deffe71904dbfcfb11b"
    sha256 cellar: :any,                 x86_64_linux:  "c0f3d5af793da5a7d391d911e660a12080b2f33e5c9c3b46844ab7674deaeb21"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", shell_parameter_format: :cobra)
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end