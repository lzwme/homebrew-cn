class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.57.1.tar.gz"
  sha256 "320772369a64517a719ce829de29338e7f10677540f83ed65892f4eea72cd6bf"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfafd48abf69790ed1a285483f249b0fe046d3915a57da02a8ac36075f483663"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a234a7144b25158b2f5e375360ac27d4e28b939fd36ebf9df764240eddcad46f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70650416f6f2033e3555b44aba51cff71fd6ebe1ab59c9684b16d650914ff4e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b67193fd8f28e3ea3bb399d7be3fc738eed38b6e8c272f0e96373ffafc75bbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e7f97fc49bd38b581e0e3def9f23481b28e9724221c9ee69b51154deb4edf2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0ffe0488ee634ae14733335ea1b706c536c7b1368317530d14eace0ad48f29a"
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