class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https:blog.sbstp.caintroducing-kubie"
  url "https:github.comsbstpkubiearchiverefstagsv0.25.0.tar.gz"
  sha256 "9707a3b7498b54c840a0a7d516a31a3e9b6a62aae4826c1b06f999f49f6607f5"
  license "Zlib"
  head "https:github.comsbstpkubie.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f3267705f0deb6ddf28644e972911d5ce52415cc6687c811dee63f49405e94a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d06df9f8658aa31fe10e529b3297644d36bfbf9652250754279d0c6148cdfcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4a50008ca2387c7491ab379c6065a4443228f0128cd6789aff7a320f7978c79"
    sha256 cellar: :any_skip_relocation, sonoma:        "6759ed224915f6734595772570ce6bdc7125b7ce100d8e584d1796e2526e183c"
    sha256 cellar: :any_skip_relocation, ventura:       "7a5bd60607814212266a76816e37288f212e224ccf71f12e3c101333000bf679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "307e2bbd03609cf02b77ea9d117af573abc257786dd3e60498db5cac949d157c"
  end

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install ".completionkubie.bash" => "kubie"
    fish_completion.install ".completionkubie.fish"
  end

  test do
    (testpath".kubekubie-test.yaml").write <<~YAML
      apiVersion: v1
      clusters:
      - cluster:
          server: http:0.0.0.0
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
    YAML

    assert_match "The connection to the server 0.0.0.0 was refused - did you specify the right host or port?",
      shell_output("#{bin}kubie exec kubie-test kubie-test-namespace kubectl get pod 2>&1")
  end
end