class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://ghproxy.com/https://github.com/sbstp/kubie/archive/v0.21.1.tar.gz"
  sha256 "9a3cac089159c2799735995aef182b2a201f8e8805461fae367414e88d3c3524"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e57f286e8d138c69de60a93700ada9f60deb9f8a7ce371423e695c7a4cde43e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e20bcc4761792253040ab667f7311a3b921cbb1c580e27b845dc65e2609ce13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1d6a34dee8ebb1d98889e2499c27c216b72334ca3bd5c123253a868a93931ce"
    sha256 cellar: :any_skip_relocation, ventura:        "e2336668450b8507bd4ca08b199c6ebcd375b2925579e35f5f04cd1133e13658"
    sha256 cellar: :any_skip_relocation, monterey:       "fc3255931c56e9f1edbb2181563f809161212d0256f2bdbcdc69484ed48fd6c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c871e3a5d31f4f259dee3f62f7adc18bd485db786b93babd2cf682a390b23ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf485a3c65bae94c21612ff1d455d863e584abc5605fd9034222bf3c6ade9094"
  end

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "./completion/kubie.bash"
    fish_completion.install "./completion/kubie.fish"
  end

  test do
    (testpath/".kube/kubie-test.yaml").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          server: http://0.0.0.0/
        name: kubie-test-cluster
      contexts:
      - context:
          cluster: kubie-test-cluster
          user: kubie-test-user
          namespace: kubie-test-namespace
        name: kubie-test
      current-context: baz
      kind: Config
      preferences: {}
      users:
      - user:
        name: kubie-test-user
    EOS

    assert_match "The connection to the server 0.0.0.0 was refused - did you specify the right host or port?",
      shell_output("#{bin}/kubie exec kubie-test kubie-test-namespace kubectl get pod 2>&1")
  end
end