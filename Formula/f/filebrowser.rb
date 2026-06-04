class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.10.tar.gz"
  sha256 "8d86404167eec8ab4a0923e1323205af988a381b9738f9ec33e74469f3a1e6b7"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38a5456fde41efc8311159d575aee525a1ce2aec5f68283f62bbabcf6e33cf92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a7f4cf84bd52cd9296942db15ed49261f6ec7ec443c050cbe600d0dbc2b551e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a14bda7ae5079687932d9c98457ed6b55c8d50a8cbf79a534f958178f69e66b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad4adfcda9844e439d80ac2d7423cf511b51ecb7227917c33eb5b76e0c5a981f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90583aa8242bd2d4e39c1a767c5239f9d956cd8ee8b22ee36c0ce23599a8d72f"
    sha256 cellar: :any,                 x86_64_linux:  "1bec04592bfe262c0627819644b15c825a75880e64995e379d47f81469eb8a56"
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