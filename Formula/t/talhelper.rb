class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv2.3.0.tar.gz"
  sha256 "a580448aeb5cbfe2a0c53d416ce87e8fe498f72fb1c2c8d46064ec479225ae15"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1472fc726e69d34c05bc360fcea729109aaca08553512cffd4c2d4806f25c307"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "656365147a5bd7c635491e26cab08d6112c790f905d129d5af63f700a2628109"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44d316681fb3a22ea5899ce8b33a1f26a96ff2ae07af7f0cdcf63f54c73e4050"
    sha256 cellar: :any_skip_relocation, sonoma:         "a02133fd6f8158a2f55fde41290770b115e555f91da3fbb3771a87a66f958c43"
    sha256 cellar: :any_skip_relocation, ventura:        "683ddbddf0fba70e1631ad74e1c534257eed3307dcc5683dd25badf7265dec7b"
    sha256 cellar: :any_skip_relocation, monterey:       "2474efa24cf08bb8535be58aedf2e7a97746f43ba24d4641a2d495f5d8b84933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27a59b3f6b105e9ca74bf5b083423d2596a74ed4314c334007bd78c1ea01391e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}example*"], testpath

    output = shell_output("#{bin}talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}talhelper --version")
  end
end