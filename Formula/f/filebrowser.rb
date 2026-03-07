class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.61.2.tar.gz"
  sha256 "9152a68331ca4eaaeccc30c9b91b3b5cdec812711bac58330f460d31f97ea5c6"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd24dd56282e52f91ae5a9a0d758c0047db11c2a64b70bc41aaa1d3875bb9168"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca9bc28437a0461676a47b90e8f494bdb1607fc020b2d938fa33ea981e1f1402"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcbc2c5d8124b70b95372cb165b721f5964b8c0ac9269b5e546fe4e7ca270472"
    sha256 cellar: :any_skip_relocation, sonoma:        "5346ce20adfefe5483901ba84192d66b106fc6805289501dc548737993012d60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e83cb36e59cf653f46aaad89d0c1f6e15b27173ced5fe0c31a386fcd6b68ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "842808d044570b455afa0ffa8726054fbf35c154ea3b6609f41933ab177fa0a1"
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