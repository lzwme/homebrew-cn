class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.46.1.tar.gz"
  sha256 "53e06f5501eaee32a89c6e1f7d211843c5cb37de042ac0fc45c25b5866f6b486"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3c54ee5f67c464edc32ec6cbe9a46d4ea484d178a40a29e173a48318850bb7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b922b51e46b7704a4d619aa8b97fe307c01a59e3de6918dbb8a1f84c45faa41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62e9a58f8ec24435d94f34676a3e9a987b0169ab4e5b7ff4f622d16ff4ff7385"
    sha256 cellar: :any_skip_relocation, sonoma:        "796883a29ecadf6aaf10e937a3cc3453bbee5bedad10b40eedaee3c4a890770b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0b34e5af2d0fe1e31f425a4c96daed65a4b094f7157250a3738d9c69350fa78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e2905c82dd03e71fe5f93952c7b09b1a70228ff0a5d6d2ebfa1d95db2970dc6"
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