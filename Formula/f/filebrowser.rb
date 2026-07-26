class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.20.tar.gz"
  sha256 "c1a5b647395be0a7b719b16b89047ab4e280def9b328c1b377656f139d031717"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd9acfde1576a01139a698ee7b2b529689c7a0a24d5432c5214192a8bf5e24e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd414670faa59476142c386ec85ae9baa4af7e7087caae98340eae48ab8ca64b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0689ae03adb7a3e3fe9b9a647b2684d3dc606d838fc025a608b05e9a38c2cf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c120f230a488cfc097d443565d2d57a8782afad01c429e5759ec74808626c57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d010d6daf191dfbf0dd57fd7da2208d723330384461d1273c4ce06c2bc4207f"
    sha256 cellar: :any,                 x86_64_linux:  "c9e2cff8eed07ba254d2de4bcd9c6b34c52ed4c114df78e4b7e30e6fab2e2f06"
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