class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://ghproxy.com/https://github.com/sbstp/kubie/archive/v0.20.1.tar.gz"
  sha256 "a9c1eddbe9e60c1d5026d405baa6a4551d197230e459d4e43f3679930412f092"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9469b4d08f8645d7620abc35d2d962aeb6f8df3bff48d8f889e09602f251cafe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "259fbdfc6039b97680fa2d3371b617d58ba83b14ca96b78be0fec1d7bad28409"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40f1d8250dd971dbce9dbba5b3589ab0a14ee3711d87f80aa41d2a0709ee067a"
    sha256 cellar: :any_skip_relocation, ventura:        "30bd529dcafc52588bd2e9f610b3b71b603bb0aa3fe942555d1d310b4eeb9ea4"
    sha256 cellar: :any_skip_relocation, monterey:       "315dd12daf4fae7167d580436a28758fcf2f50a8049453dc9f29559349b18550"
    sha256 cellar: :any_skip_relocation, big_sur:        "8982622f65e5eda9f81279c0fa56db44bedd8da5f5716cdfab8e6758678949d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b632899e7853d744754acc58812ff8f529033c5ed8fc033898c3f59e8939043c"
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