class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https:blog.sbstp.caintroducing-kubie"
  url "https:github.comsbstpkubiearchiverefstagsv0.24.0.tar.gz"
  sha256 "a1ed2272808eeb444adcb405ef385e1f03cd0d4f4dc12f4418ebde5f0b1789ac"
  license "Zlib"
  head "https:github.comsbstpkubie.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7343146a2388c3691aba481cf5defdca6d6913095e4b544b23151d61562796d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "830d06fbd3b2f588ef331f751cd694af46b4f811a993d1c2ed51a59a9ece545d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8108e8f3f91b0cfaed27f2c4b71da0e4c9cc7de0b7c0a727de6f12bfcb8d9754"
    sha256 cellar: :any_skip_relocation, sonoma:        "f221a79f589a3f85eac3c86947bca0cec07d290c251b360060ac77f3aee5d930"
    sha256 cellar: :any_skip_relocation, ventura:       "f8485751ca3b749db750553071560317aca7c30c3163bb1611ddeafdb3f4f548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c3963e715e4da8aa4fc72ccea9733720fffc96c12fe7376189730fe6662898e"
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