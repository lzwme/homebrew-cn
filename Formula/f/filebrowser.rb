class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.45.0.tar.gz"
  sha256 "fd7ed8dff59cdb11d56d76dbe739d341780e08ebcdc2ee5833849ccf8090d809"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d243c9db264104198f80074626e4089de7f11a4403e5ac68fa3306af98fa05b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caa18c6be7571fd395bca286fb648341e0ddb6bddb0ead9f57ff83b1a2456623"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f60f78b3beb0764fc4d30956b8ae7dc98bb8495550b56976343711dfc95001ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd0f3cedee2446e0b033a39ff31fd94b900a8bab05af007225a11957417b12fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff2dbd142c11603d5712288d2586a7fcd95d5f987a5a341673799a4f428bfe85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8a32194109fc42fbb3c6e715acef8f3d5fe66cf42443abc6048fe232aabfd26"
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