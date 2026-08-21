class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.122.tar.gz"
  sha256 "0d9f0062e94d7c2eed4eefc9194c09377186efd7966a3c4291459cd3fb480421"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce39653807c77eb9e595ecfc31be016ebfc1ae1d79d6849d16fbb7c03ee56ab4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce39653807c77eb9e595ecfc31be016ebfc1ae1d79d6849d16fbb7c03ee56ab4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce39653807c77eb9e595ecfc31be016ebfc1ae1d79d6849d16fbb7c03ee56ab4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8062a0d9b6c40227b8e07318e4390147ee562672b4613e8aa05486ccf80d47ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c522fb933916fca5b7b5157f15558cf21b435c1aedb50fbb2e08a48d21c0ff22"
    sha256 cellar: :any,                 x86_64_linux:  "c7011adae92365f334085c4620791ecf8126b3ff4513f93c4aea6f003afefc3f"
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