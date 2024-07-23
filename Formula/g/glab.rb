class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.44.1/cli-v1.44.1.tar.gz"
  sha256 "59502833637aadb7c88dadc3c2f826cbe185a8fe7c0b90d82ccaca1da9d5dcf6"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff19a9daef4600cbf3327dbaf2486357beb5123057b576677f4333600dec981d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c9f56ac1e99c9dff2998d1eb27db954c82e790fc2c10f90fdd3c56a7d63169b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b6f27569be40f4d10d648116c8f1ef76e6a5430bc50755551026107702aa56c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7deb693f4d6638edec64ce158c17d24edd507439d12e684fc27953df816cd4c9"
    sha256 cellar: :any_skip_relocation, ventura:        "19d36e8ac4b2449a0c1765b4c029764eec47b1eb4d7a9180dcd157e32b3ac569"
    sha256 cellar: :any_skip_relocation, monterey:       "ed5012d871a33f099688f622d94dd69ca8babafb850b4681dac5458bb349e53c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "405720153aa65b9affdd7ed8b711fe811449c81eb220da077c53f65a17054cfd"
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