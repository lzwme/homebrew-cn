class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.10.12.tar.gz"
  sha256 "6df5c19b9bc611ced501c05ac6fdf4bda5b7d752701bd800b5259ccaeb08824b"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88d6b6aab5489e899da4a622d876af57fe13609195a7c897c838303a8b1157f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30211dd8905eeca1163d2c9044ec663ede7ab0fa5a2a6b27453137c1edc0cf2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31f4dd817495067c859fa90442593d18c62b7778840f99ddb94d0a5064c392fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "92cd66f875aff28900d69594d91564797d2c060680b4dfd22e205422faf8fe71"
    sha256 cellar: :any_skip_relocation, ventura:        "09acccaeccd56fa5f1d8e1a8fdb6471056650e622fc7cba23d61fc2d5b3cce49"
    sha256 cellar: :any_skip_relocation, monterey:       "96e9dcc8dd3f3fad72a1c62636cfa0a88afb20f5eda4ecd46bc1b7d960ed45c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f487ef0200e4d758d176db43cd7a578260f7919e467424108b89fe1d25a2bece"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags:), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end