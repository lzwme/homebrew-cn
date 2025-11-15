class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.46.0.tar.gz"
  sha256 "e2917eb4dccccf27db1db2d29cc2f4da6a5508cf59a5d021655441c59627cd08"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ceaa87539e7a15c385f99441d1cef4ea4b27f7501ed460878005fcd0917f21b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2292ca7a59f7579d4541e799e722f62ab540a89ec6fed3951ffe7cbbdfa7367b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89b3448d1dab04c0d2c2f7eefe2426d44d764abd405714af71fc84752504381a"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfdcc29a0e96e93647e2e7f926b08f653f38e1f2f38b04a832c33503b538fd3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35bb67270709d592b68df44fe52890b4a10aa22666fd492fda874b6d3e713045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ada059ce5798c5a43e1ae81c0529fe3e4337924dce0a28247fd4f4b78500b3a5"
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