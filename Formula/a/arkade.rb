class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.10.17",
      revision: "3da76f9df8c251560b420a90ed27257da6529a5b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc8c15c5bf921171956292cdeaebc42b45f7856dfbfa43409665f7583ebd4dc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "864d41b6e177283cddd8b427777c88203e97e6710a3c619ccb80ee648f00722a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3984fdfb8cfbe257094dbdf8ea2bb176aa29d73412fbeee2d2892d45b12f97f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d8ea2ed3989e2674453872e6e166f2ac5cb7fb7d69df1917e95d60b1e5e0b24"
    sha256 cellar: :any_skip_relocation, ventura:        "eadb097c17cd92745fc445902ab6f1c34225701d5d033e2ca473cf1dadcae100"
    sha256 cellar: :any_skip_relocation, monterey:       "419f7908819aadfbfeb1a39f4bc10a6c2d2a62a70e94520cdb732b9dbd236b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54253ad5ee9720829d61fa77818ff055a6e368287cca1c2a1194405fa9e8f2e3"
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