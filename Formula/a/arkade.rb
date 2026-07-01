class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.105.tar.gz"
  sha256 "ff8594d32ef7cd900940a03983ee7b30cd4c9cdebe487f96002acbfd88709050"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7720dfb8335c2bfeef372db9e144aca7fabc764a7eeaecfc1bb03a567abcc36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7720dfb8335c2bfeef372db9e144aca7fabc764a7eeaecfc1bb03a567abcc36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7720dfb8335c2bfeef372db9e144aca7fabc764a7eeaecfc1bb03a567abcc36"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0d28a23698b8e2710fc9281b517dd001fd9c048483cc25fc777214491685c0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2964f3cf5341a25406b437a555b24c87d0805915b8ccf0ea8a81d6bf68412fd5"
    sha256 cellar: :any,                 x86_64_linux:  "38b5af5e7267f413bf6afb20be2f1042c12149f074fb95ffff723c9b2a8d2795"
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

    generate_completions_from_executable(bin/"arkade", shell_parameter_format: :cobra)
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end