class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https:goreleaser.com"
  url "https:github.comgoreleasergoreleaser.git",
      tag:      "v2.1.0",
      revision: "2a1bcaca534197ba122e76812d842aedf61930fe"
  license "MIT"
  head "https:github.comgoreleasergoreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a5e4f6a0352af1989c5516ad2b742e132bf5112e2574190b6b706f7b1697f35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7baf75e08e8391c0f38c3ef99329f81cec4039c0ca36f9626a0c989cb68f6565"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e67013fda42351e23736b660e27e24d67023436aa9628da8123022cd291389ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fc3b5a897495cfdb8fff3424cf29437ffcac86251b44a93331b99271d77feec"
    sha256 cellar: :any_skip_relocation, ventura:        "747e482cfeb99ed3af1ad0810cf4c8fbf47204c43b966b51043e402cb718ecd2"
    sha256 cellar: :any_skip_relocation, monterey:       "5744f142229bb2e2acafa83a78d73af211c1a7f0b10825972e85b2e4a20d1036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a1aad170a4811bb4b2e8c8ac9c9e13221c9a6ebb37ada3e697049654d33d589"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath".goreleaser.yml", :exist?
  end
end