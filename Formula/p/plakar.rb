class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://ghfast.top/https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "6b2bd80a0ff83ff24df410526ebd16511d9d0c2c8ea2cc585c724cd140412743"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cddb115838d05c253a6faaf2d0b1e5f8faeb1976a3d2bed3c67b2e74bbccf55e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d0f0a0fe54ad0409a6258c22c21fa1e85a904bcc86b23f57e506cfc79657f98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b82ea806131cf269785af68f79967e4e5b1b8f30456619496e3b01664c501988"
    sha256 cellar: :any_skip_relocation, sonoma:        "42b74844170ac712cf39c61f7bf5e13ffbdcc6c39be9c95153ba69f28c79ad2c"
    sha256 cellar: :any_skip_relocation, ventura:       "080cae3db5e1dc4971862d836cfccdaebcb48365f1647cc3e6ffdafd0e066a48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02ac82be4f8dcd3aefdeaac73d93075932cd2f548c8e6e388705841571e5ddc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2749a0eab434179223d27b9f0aef79d8a37250f3ecf711f2cacc725d896fa2f9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"plakar", "agent", "-foreground"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plakar version")

    repo = testpath/"plakar"
    system bin/"plakar", "at", repo, "create", "-plaintext", "-no-compression"
    assert_path_exists repo

    # Skip linux CI test as test due to `failed to run the agent` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "Repository", shell_output("#{bin}/plakar at #{repo} info")
  end
end