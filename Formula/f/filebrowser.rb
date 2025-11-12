class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.45.1.tar.gz"
  sha256 "8c1076ee39ecd01f4e887f5d3d8593f4ae3d75f0cfcdded56cbc3d773e2f07a0"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e5b04b021cb5c771a3159470d0c2a2564211fda38275344766267c6a6764014"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fbbe303b08bcfacbebfe7450839f6fd593c8c8cf098c59c2335ad7d6200667d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe09d9607a77c5977bc2dcf1dbb2b14a6700546f9e028c602780abb3e08f6645"
    sha256 cellar: :any_skip_relocation, sonoma:        "58ef18ffa2b291b2e4623b007456a0f453f40c0be15c569f8b5b7bdf55b713ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b746941c86b1ffdc43f5fdfde0f8ad57bc25b9e531bcb4259074eaa849efb40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0550a47d93f94b9f30f3271837a45d833f35c0ec9ddad6edca2ae6fef6a1e7b7"
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