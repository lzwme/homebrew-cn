class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.39.0/cli-v1.39.0.tar.gz"
  sha256 "1426c717b090248bef44c26bcc05f34cf8512201fc40eb261b7143b41052a2ad"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02a662571d6d138883b0f69de84b37d06096c2eb73d3ae8db192c1f4c1814a21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdfb98f9ec288011f8d0f7df9794eb48cbb3c3438d8d986dd06cb95114ba6342"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4b7803299e81df008ecf677fa545f263232daebe021a46376d9b8709543f520"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ad91fb8cc3863e4e42a447197d02e02833f3dad28d004813bae86244d6fdb14"
    sha256 cellar: :any_skip_relocation, ventura:        "c0b090531018da5baa2af18c3fa6a3fbe1fba6a23c705eeec1b59feaab4e58e3"
    sha256 cellar: :any_skip_relocation, monterey:       "ff855fb5934709594001c2a89fb9b12afb535d930470e6fe07d8d6afccc617c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42fdc1e0c1e26c81b5a28f95a79baaf537c15af11bebfdd4aebaad7940f70ad7"
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