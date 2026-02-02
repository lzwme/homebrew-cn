class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.57.0.tar.gz"
  sha256 "851318fd1b48491d84ce7598a235c8c38dad1fc950349ece78a140c4f8176851"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ea7c3bbc6291e85f3849e23f605c10b9d6c729d2d314538474729c6e503a2e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f309b17d9bb2c5eb9aaba0fdda0f64e659bad89ca73d14455b7bbbe3b8ad9309"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ca9a1d342335fabb9bf0554d31e126fdbde18bee6b9c76bde77426afb46ff08"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1b25a44e0cf6b7569b37a093dc1b7be78c5966a8cf24a7ca97872d91dbecd0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cbd81c75d245c448f45270c6f3d3b5d50fa14f27e4d7f85af6c9c290b51ae6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22b85ad6f6f880381c08d83329b30dfe176474ac8e3b12433f9c264a112243dd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end