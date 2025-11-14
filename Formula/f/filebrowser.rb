class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.45.3.tar.gz"
  sha256 "433a79deb0bca31cabfb17e5517728a32dd6692070e520f9beb8a10659e3e0c6"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e1c452a11701ca6a86196d1497a509ec9456e1c288d77a5d38fabe04c144750"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b24bb76656cbdb204bf7045a68a0cd7d570f97c69f85596426d895a5eff0b97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1210a1efa5dfa8fd5724b8c445ecfee7dd6d97fdc9ee3d314f316e7826344388"
    sha256 cellar: :any_skip_relocation, sonoma:        "7336f9b4852b3792ff8cd33851f3160ac7842dadf57a1517d9ed4b4a50fa9334"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d35abaa89beed9ed4cf4821d699ee46d2d0678b586fc1b043f89f62f62776d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83e1d6a1b4199bc10b4fb46da3213abb9ca619a973fdeed9a30ba3c1a8def948"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end