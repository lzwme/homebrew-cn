class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https:github.comcodesnap-rscodesnap"
  url "https:github.comcodesnap-rscodesnaparchiverefstagsv0.10.5.tar.gz"
  sha256 "814ff5cfbc546623587c8dd01db3ce3320daf1b354c02b3bedbd1fd68785212b"
  license "MIT"
  head "https:github.comcodesnap-rscodesnap.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9085159ad167f1a9373ce3ab3c0750fd4dec188a6415af70e68dc47cd3a1eed0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "849869809804e9e7b78b0bd08d0b57e3aa9d4f228deb402b84993e8d8d1e3a5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4573982698fd19774bef166fc7a2898ef3ca354e58c6aabc81821d187c3d06d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a7624a2c493e0011d72048cf5bebbe1204efa322171af57d45ac2f36e2ee9b8"
    sha256 cellar: :any_skip_relocation, ventura:       "1cd2fe459aa0e56dc112b18f5c16e7c0978bc5b52a1711a63a5302ba8a59f48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3092d52c4bf186ed27f637fc7c91119cc9a782863fa16ac59a21cac5a72a60f7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cliexamples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}codesnap -f #{pkgshare}examplescli.sh -o cli.png")
  end
end