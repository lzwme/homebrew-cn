class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.9.0.tar.gz"
  sha256 "fade74e232af6a48205b520aaa50e2cd9248f61fe0d4d8c3af7b687bd3b5afc7"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "265f08158cfeb6654687e021f8e80dcadda2c6da38b7e94cfb3f4a167f9a6ac9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9bfcb8e7ea4bb58e8c6a0fc27f95ef0f2c30027af44ad76a6406f50f4f4835e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8af4b30bf5bbd91d55212bc0f9f86e3b530236d3128f57c75ada923520248d2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa81d9bbb254058802be646f4d840f7599702ee3342170c091f8052f966f6235"
    sha256 cellar: :any_skip_relocation, ventura:        "8e388df60afec68efa33bfbd13ead97d530e53a14da349abe92f909cf015f843"
    sha256 cellar: :any_skip_relocation, monterey:       "7ceba36003a960da749be782f35b82d0c2395385adb8f260918d4af8e038bdb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a91eef4ca4242822fed5368080b3bb47d82b21531b8fb29bd19d19ad36a4db94"
  end

  depends_on "go" => :build

  def install
    cd "cyctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X github.comcyclops-uicycops-cyctlcommon.CliVersion=#{version}")
    end
  end

  test do
    assert_match "cyctl version #{version}", shell_output("#{bin}cyctl --version")

    (testpath".kubeconfig").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http:127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    assert_match "Error from server (NotFound)", shell_output("#{bin}cyctl delete templates deployment.yaml 2>&1")
  end
end