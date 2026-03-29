class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.62.2.tar.gz"
  sha256 "a10551b6f319d90862980c1def9aff81d6dfdc3065e4df9b3534a1203b6d897f"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b638ce8fd808a9410041483673338cb28d8b316bbe459e6773ddf2f187e5a0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21e4bec0dbd2565685de1680d5c1f99eedb65ef0a8fcfd2b3492eec6ee631c8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a22a72d0d722a02d8b8d4b3a58ea3648d2681bc696aa20fb9394668fb0625c64"
    sha256 cellar: :any_skip_relocation, sonoma:        "81cd6c060eedf11f1d8bf0509edef022e0f37604c23e29b584f2d90be7884d2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1827a18edd06c6404915702fd6bd2ee2626782a566f35431e548a6b1c2eeef08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36f319504fd0d417c20b5e66e8351bde1b4ed4942d737d6e5cea97a7b25b8a7b"
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