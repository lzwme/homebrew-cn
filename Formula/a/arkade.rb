class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.41.tar.gz"
  sha256 "44e58d2f0b53f0b955fe40fdcf8dc11f9038e2f3684b5fed50862d01327a11fc"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad152624a0389e9fe40cc57d9869ef4f34bd04e01ec9067d485bf64c8db7126f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad152624a0389e9fe40cc57d9869ef4f34bd04e01ec9067d485bf64c8db7126f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad152624a0389e9fe40cc57d9869ef4f34bd04e01ec9067d485bf64c8db7126f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d877287e2155317bb3a1f2521ea8cb86f863a8970269277b4e480c50decf9ad"
    sha256 cellar: :any_skip_relocation, ventura:       "3d877287e2155317bb3a1f2521ea8cb86f863a8970269277b4e480c50decf9ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb61a9add1299b20ebc89d75c4935b753211f26e14530ee79fcbfa7431544cd1"
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