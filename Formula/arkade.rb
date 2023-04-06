class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.10",
      revision: "ebb041e0f9f837c650e89a9d5718578846e9bd2f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "392bf9ff210cd234800ff6871ad43b2059ed3cc159dbfb4e6582c107c1233080"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "392bf9ff210cd234800ff6871ad43b2059ed3cc159dbfb4e6582c107c1233080"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "392bf9ff210cd234800ff6871ad43b2059ed3cc159dbfb4e6582c107c1233080"
    sha256 cellar: :any_skip_relocation, ventura:        "cddd810a98774b4a8d4d0c2826b3e9de424ea3c10ff2f337c2d975752b690bcb"
    sha256 cellar: :any_skip_relocation, monterey:       "cddd810a98774b4a8d4d0c2826b3e9de424ea3c10ff2f337c2d975752b690bcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "cddd810a98774b4a8d4d0c2826b3e9de424ea3c10ff2f337c2d975752b690bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f2b525bce5ae12c28c8d617ea32b30f9f0ac0ee0c1ccc157450cf245c30a032"
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