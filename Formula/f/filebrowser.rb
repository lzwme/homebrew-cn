class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.52.0.tar.gz"
  sha256 "f0a78ffe3f296b01992fe166b4191eddd7deea2e00b9449f748072391dff48a9"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79f1b75f8b5318cc5fbc82dd1ff67ff6dcc040c7ea9dae1ae5c1ff5da74b2a7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "868c0af66283639a4142e9ac7c3760d3e8c7947649444c44761e669a4ea8dc43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82e9f6e4631e999bdade71d3b681630c02b8ce2f60194c8121d4497767d0e44f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ea99bcbba0fe6ec906031cc445b78c6435ec3e0ace377e30c6931dafc837ed4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2ae212c4a2e5ba2a22ce27fffe0bb6cb6249867286544ea6bbf539828288091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "959356e80c01530406d710b9e41406841af9552abf55cc491c8baf671b523c23"
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