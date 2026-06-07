class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.13.tar.gz"
  sha256 "22437303339b68ffa889c274aedf7c7d56fa9f6fbfa33b1bf38317bb3745efd9"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf2f04c207d35417ef5b964c3c0df48ef7671fbca4de26344e7a178edddc79a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ae15c49a93d29c26d8d4fde19de8f1bacb9310d568596445e60e2951608dd8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd70562fdc87b79a9552002ead53fccb4ec7e85b05f9247d846d81a6316d0639"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bedba8aa65aabd3f4e6c8d9d8694762222328cde43384b42c36bf099f3eacd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc3c2bd019f526e6706e18b75ee9cf5b018183d7254955724f1120400cde125d"
    sha256 cellar: :any,                 x86_64_linux:  "6b1258b8dc543c26dda53c770b30fd2b6695f0d81ff9ff17d5616e79df72ccdd"
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