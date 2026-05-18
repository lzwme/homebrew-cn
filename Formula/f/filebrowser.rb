class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.4.tar.gz"
  sha256 "d111f6f2b2f047354c081c0a1b218a7bc5950487fecd4f6101208ec27fd5d6ab"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a46bf17ab33251fa9424d05743bbbeee7d4cc321cc3a89f56403db95aba4ada4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1729bc05c6263530e9841debab114dc8609d75aca8cad16d13a639a99d6ce02c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de507521c0055f90b3c877c0e88f58db519e23a4a9438e9c2bf51ef3b7a91180"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee4191f8318f53dc2efebcecdc1f5817760ca3c965e1e648dfc878dbdcbc653b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdda7df145eef7ae96716c44aef80b783b6474cd847ff473a060919a8f4dba51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dc8178e98ceb3b865fc2360a36e807be84de853dff64e37bdf0b1c3d29cc45a"
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