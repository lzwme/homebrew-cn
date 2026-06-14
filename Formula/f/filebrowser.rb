class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.15.tar.gz"
  sha256 "fc7b597642769ce47b590933e3b1a345154ea8877817a3a4106e23f24dab6705"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6124eac5cb0783bf43986bb5d522a978fac26f6536450d26e1dc45998a9f681c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4e438604d7462e36df2baa3de6a45bc755579ec85c7a3b9e75a8e43b027d15d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "562545ad76df6ce122aa16b3e083b4a681e852676c0b3a021465edf6fff57554"
    sha256 cellar: :any_skip_relocation, sonoma:        "b37e251d65748ef1a242cd7f76e2ffe523adba68cb8ca778af4eb26ea2ca863b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9371f4013a5385c1a1a5dd780614a7e407ffe73269aa00ee2491c40b6b8e0337"
    sha256 cellar: :any,                 x86_64_linux:  "16d44a87080395753aa1a67abe31eff9d5df72cf8fa4ae24de5478acb9dbc709"
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