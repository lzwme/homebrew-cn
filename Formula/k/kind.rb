class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https:kind.sigs.k8s.io"
  url "https:github.comkubernetes-sigskindarchiverefstagsv0.21.0.tar.gz"
  sha256 "8311d394bb541f8759a578c719a8359c26cba2b43179eadff10bb797d276a4b1"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigskind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8148f05892b103b227f81bdeb8f3936b05c2b4760ba32f89d2d5062d159d4c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22ceb6b78f1f15b882589feb0c8ccccfcd9a6cf479fd93e3a3640d0c1f7e0ef4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c4b2454480e45a8048021ba23d7ebb36643c3e9dfe00b98ce77ea26446c8ed1"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cf5445dbe063ee0c7c4fcb7ed048b75dc9755e561c732f4904b2188d8674c27"
    sha256 cellar: :any_skip_relocation, ventura:        "36cf2d0ab6b532d53600f337aca7d0f6005aee42df59eb4388ec026565a72a26"
    sha256 cellar: :any_skip_relocation, monterey:       "28644cc3c8e1ed25b19f142473982c94b88cc8d980647c9a4e23d49bdda42682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b39ade623ed37900977af696f0f92a3fadf209f967d32029367fdcc663d721a"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin"kind", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"

    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", status_output
  end
end