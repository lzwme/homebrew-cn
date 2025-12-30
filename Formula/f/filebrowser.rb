class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.53.0.tar.gz"
  sha256 "7abd0260e8a5fd1fe29477939e2613b0b9164b55b1706d3cc2682048354b38d1"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "345d53b5d457596b1eb7f756dbab3616abc7cc9241e27c96324071d32020f94a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0728aab8474831e0f25816796c31d841e88dacd4d654e21f61828a01e1023118"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ddd7706839d4df496fd3ec4386ad4b4df3d4cb181cedba9abf30fde250150b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e671d5bb97ba2a528098ac666e3c15f8e59add7c7639406edc3881b523f812a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f28755cc9c5b12d5162c0a85a6638d39bca33738814a4719a0b220b5a792653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60b06b7a405839990ebf62530b2f3c078512ad67bd5944d0e3511935697d27a8"
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