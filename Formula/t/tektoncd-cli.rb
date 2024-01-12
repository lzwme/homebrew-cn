class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https:github.comtektoncdcli"
  url "https:github.comtektoncdcliarchiverefstagsv0.34.0.tar.gz"
  sha256 "232f8621455f01a398713c04f306301cc8224eb68c75234219269917965ad371"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb9604dc605b4d1d46f1cb7ea6a10a58e5041d5f9ef62b59e0cf4eaefbd93dcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7c9540b677fc8b35e81ed661c293681b02ceb428469ca61415b00a7bd5dd1c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b48f14a9c711088800f92546651e42056709f3011880d35976bae6d0817d636f"
    sha256 cellar: :any_skip_relocation, sonoma:         "aca5f642c3c11890b45ae8648142577d6c2e071c32b5a2fcf97d9aabbdd82101"
    sha256 cellar: :any_skip_relocation, ventura:        "38a2afd392d8cdd79d04e81c227fc5c80ec85e3f35530cf87451c0c27bd06293"
    sha256 cellar: :any_skip_relocation, monterey:       "9bdae198380b78191b11eb13ec2b3529cf900b770199cddd4f663c337a04aa61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "329ac0edabb82dbbeda5b62bb9204343f4001a538cec2b8c1b8f57c449688319"
  end

  depends_on "go" => :build

  def install
    system "make", "bintkn"
    bin.install "bintkn" => "tkn"

    generate_completions_from_executable(bin"tkn", "completion", base_name: "tkn")
  end

  test do
    cmd = "#{bin}tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end