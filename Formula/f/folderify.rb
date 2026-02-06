class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://ghfast.top/https://github.com/lgarron/folderify/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "90d8762184178a7631e539ed0a0239cd96ea49efce12a3b040db285b8594976a"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ca2f46cfd315963678ebca13ecd064f12370050a8d79bba1cb7934dd7c17d1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d49b89c39503345f913554af7512c35593d37bf7b6f3a3a3465b2d0ce00a521"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "697e7462c2468bd200c63dd65323688f03e0937eec3a0f49468d4c21be9d3aa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d978efc668937dcf6274e9e230c9ea5c51eb8329a688ef201ec6d4c7e17857a8"
  end

  depends_on "rust" => :build
  depends_on "imagemagick"
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"folderify", "--completions")
  end

  test do
    # Write an example icon to a file.
    (testpath/"test.svg").write <<~EOS
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
        <circle cx="50" cy="50" r="40" fill="transparent" stroke="black" stroke-width="20" />
      </svg>
    EOS

    # folderify applies the test icon to a folder
    system bin/"folderify", "test.svg", testpath.to_s
    # Tests for the presence of the file icon
    assert_path_exists testpath/"Icon\r"
  end
end