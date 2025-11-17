class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.47.0.tar.gz"
  sha256 "f90b2a9981545570006c0984aa39ee7178f4efd71d1ddf660c8661ea2f9bfbd6"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b4c56bb9638d2bb60f845d4e4b4aaf8520646ddbf01b2ac2b67ef82d62a7445"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "520562c15921623fe1f2277cbdf5b5995f691961cd9a1149721395502498c0a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22ad96eae7b1bb8d45c92eb423bbc3b0d0e631775c785cc421d2a4cada81a9f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3332635f2b7ea2c99d32e9033784fa47ca761eecb6edadd5580ceeebbcaecf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ebf5c8d2800dcfae12033550a45c845ee699ea149fc04ae1735d84faf931e6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "555be5665cadf4f36b5b90d06f66e6f4013ab218faba7ec1d530ec03422dce2d"
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