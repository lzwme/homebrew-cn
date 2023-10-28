class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.13.3",
      revision: "0903a7d05c8b9e159f2739b3026e59716a8b65d1"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab028937de54cf901a6391b7033fdfa2b4b40abd8b83e5b6ae09a2255b994819"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eed09e9f82279e931e0d4d2fdcb8b531798f216cd0d406541aff134cad7b388"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52598ce1d9ecbbea1b8adc487f16de0c7b66eecf85d124251c5b0e681fc9260c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fba019511bad06bc2cfcf6a8c16f3392e5bd9dd41ffc3dee6839291aec5826f"
    sha256 cellar: :any_skip_relocation, ventura:        "9a68ff68cafe6bc0f5f7cb289485458447b85ff7c3120d1e146968139e20ed7c"
    sha256 cellar: :any_skip_relocation, monterey:       "eb72882ce4ec75019a33d08f95a7e8b9f4099d5fa6f202194ed5ac2522ecebcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2963db7da5f990e61d10acefca22ed6ff42f98c495af6d6f89830a29010b4346"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k3sup", "completion")
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end