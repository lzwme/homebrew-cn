class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.53.1.tar.gz"
  sha256 "68f55a90cf25c4e147dc50d45de2a619f4b24e9c2f6fa7c7de05130ca0b4e123"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75a0543b2ac35355d25a859bf8a6f72d6236b97eb03317447f447cf6fe83c891"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b9e5a126d7eafce129f53b9564000607b4b2a0be9c06b60d1042d1e41cc067a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19dcd95426b9f447cb39bb74e5b7a2ea4f4cf20b0a1e93c9993ac445f975603e"
    sha256 cellar: :any_skip_relocation, sonoma:        "86ccad4c531ab192b16c5ae36d017b95ed8bac0536519172d8cf9470456b128b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e09c2503cfafa1b7f5b2dd8c094ec901fe8d509a7a18d083781f8cbd4df680c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4983ab0554b5f7401f17f9894e24ce12ebf1f052262ddcd7731a0d6edab84c30"
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