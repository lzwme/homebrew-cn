class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.43.0/cli-v1.43.0.tar.gz"
  sha256 "0d3a8cb750826ed4392d7c1b681dbc280f43fbda01c7f5ac566e9a1eeb669f55"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "730f5330572304ab728d26043d0bee4c8597e6ebdf3795fd853a55118321e228"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83e87e95f7cc427c5ba3aded639a39f0adc5ceb4a0b51021f9ae827c4fe368f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "580f92e990407c5c42273aa5535c5df6df05c3f811411008ec8331e3162d3b0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7fe05a9d39bf6c0265fdf48b66a2ec2d05ad3a9ef9fe57d4d17bd86f4032b51"
    sha256 cellar: :any_skip_relocation, ventura:        "ae055a2547bf8bd48cd9b84078681ebb1ebb706b10082449513dd5d97f364921"
    sha256 cellar: :any_skip_relocation, monterey:       "159d362bbdae7df9f3725cfc020506e49afc9e645ae3a3c110ab28d7e339e7af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d056ad8f92ee7cb1cfda12c0bb0739cf7df4ac955e7e7d0394a1b2f6b62e5b89"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=v#{version}"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end