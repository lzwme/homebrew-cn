class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.58.0.tar.gz"
  sha256 "6b8a089ac045650aadf06e0f5024493dba6b09b11153a56ce816cf72d291aa14"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7706a81e2b7ac8480147d4440c6d1ae6aa161e4d73cc6652622f7af37715a40e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a15c90a2f8f3d726736ea2804cf1b8dcffcfad74466aa3141f7569684c1e5e8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10c5984ecdefb8bf84b076bd956ab4aaf24808f814de9e2aa49a914a2f01216d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5ebfa9b4ef92f3610155cbe35c51c9c3e56adf606d55c55c0e4905f1c78ec15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3105aaf15f1b2b23631b0ce86ef755ba2f429e2925722e8a61a61f172f4328b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eee45e1857c16a226ac8777bb25b19e8033f58d78acca81ea3ffdd4ff8c4f777"
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