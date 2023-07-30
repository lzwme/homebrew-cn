class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://ghproxy.com/https://github.com/sbstp/kubie/archive/v0.21.0.tar.gz"
  sha256 "9fed8211d38a9f2d0985cc2ba06b56f1a603f54dc4f058bb4a48b962624ae4c1"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ab6c926adc3da26a26469ec6ba6c79675987c68aec8cd769730c09497ad06c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19b38066126891528ed9e22f53a524ef575bc8e05a123673b7a204d10cdb048e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c8702a0e97b9d86d7ee0248a070486d3beb940fcf1027480ffecb9bfc23bcfa"
    sha256 cellar: :any_skip_relocation, ventura:        "3398cdd82e0713bc1c91d3d5b1af09054fce1804f6ef162ecdfbdda16b3def07"
    sha256 cellar: :any_skip_relocation, monterey:       "e0ca4fd40885f8214787827b2ea8d7c82db1f821249381387c415d609acb75a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b63838bd413b5a6c540aea80de68ee9774e06bca861c2114c039fa94606d2b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a242aed25257afc676c99a8782c11297f659c422096644561665d0e82a7bd2c"
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