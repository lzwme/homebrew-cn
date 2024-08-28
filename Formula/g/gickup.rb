class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https:cooperspencer.github.iogickup-documentation"
  url "https:github.comcooperspencergickuparchiverefstagsv0.10.32.tar.gz"
  sha256 "4471aae40f256dd28163f1c3e56d595dbe9fdf48c5e70c6d380a2d1f34329fed"
  license "Apache-2.0"
  head "https:github.comcooperspencergickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d328adc23d75eee8e0d92eb70b9059aa1e0e401fd72546639f959f1375af315d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d328adc23d75eee8e0d92eb70b9059aa1e0e401fd72546639f959f1375af315d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d328adc23d75eee8e0d92eb70b9059aa1e0e401fd72546639f959f1375af315d"
    sha256 cellar: :any_skip_relocation, sonoma:         "32ef51c5eb9d13dc8b7822327e74eddd740830d9f84e40ed53e7f71e50a3a02d"
    sha256 cellar: :any_skip_relocation, ventura:        "32ef51c5eb9d13dc8b7822327e74eddd740830d9f84e40ed53e7f71e50a3a02d"
    sha256 cellar: :any_skip_relocation, monterey:       "32ef51c5eb9d13dc8b7822327e74eddd740830d9f84e40ed53e7f71e50a3a02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c70ef9393b52f90c2ae4e346c8b81b5843097f8d758a15ab90d648e7d65935a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath"conf.yml").write <<~EOS
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    EOS

    output = shell_output("#{bin}gickup --dryrun 2>&1")
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}gickup --version")
  end
end