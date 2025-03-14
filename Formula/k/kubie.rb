class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https:blog.sbstp.caintroducing-kubie"
  url "https:github.comsbstpkubiearchiverefstagsv0.25.1.tar.gz"
  sha256 "b025db51bb95d1b585f3fbf5700deac592880904b67b32a30182c5d9af216b5a"
  license "Zlib"
  head "https:github.comsbstpkubie.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "255bb3b545ea95f7f53718820fe5506a6133f85194b153c469c766e1f9f969df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfa938269222460b61f874d8bba2267b14f03377613b8b9d5a32eb70f92d933d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b28869ca3c60611f92af5c38770c969a04d4f00b0d0bac2bab1049936c51176"
    sha256 cellar: :any_skip_relocation, sonoma:        "2213fefbd8804af9a21e2edbf6c11bb4b5db4fb717fe64610ebbd8fb78b207b9"
    sha256 cellar: :any_skip_relocation, ventura:       "899ac3f82060e8a2d1969875b5ba773bae9f781dd97df19331faf43ebc6ac814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea7e571e00ca7496dba0631bab8cd30ea6f25b04f4b347729e7c435bd6c136d6"
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