class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://ghproxy.com/https://github.com/Checkmarx/kics/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "faf3904ecadae6908f09ddaa2517b8d1138ac76bbecad1f248e93de2c552ac6d"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "972e01a81536b6147a072e2af90e81ae981484dae5faa5655fc70e3bb0737bbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d299d96d7e2dc97e5622661d5f8dc5f089f76056cc182818003c136d7caa3c45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2682f40c3b35c954589a172841d13698717c8be4aa58d53618d000a6a4a3bb2c"
    sha256 cellar: :any_skip_relocation, ventura:        "8f3d8525327139b54ba99f81aec19ee3d807323219b5663aa4ff0874feaef2d9"
    sha256 cellar: :any_skip_relocation, monterey:       "83680c9db35318ec7118598a1e510a0fb510083df77d5beef454c12eaaf8fad8"
    sha256 cellar: :any_skip_relocation, big_sur:        "bee9325459b80b3fab673d3e49b15b67625e4e9d18cba0af20e6049cf59b2b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c199a80b409f31ccf710c9c7a1b5c59fbd85a6477bfd70c6af1670dc48fbe519"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Checkmarx/kics/internal/constants.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/console"

    pkgshare.install "assets"
  end

  def caveats
    <<~EOS
      KICS queries are placed under #{opt_pkgshare}/assets/queries
      To use KICS default queries add KICS_QUERIES_PATH env to your ~/.zshrc or ~/.zprofile:
          "echo 'export KICS_QUERIES_PATH=#{opt_pkgshare}/assets/queries' >> ~/.zshrc"
      usage of CLI flag --queries-path takes precedence.
    EOS
  end

  test do
    ENV["KICS_QUERIES_PATH"] = pkgshare/"assets/queries"
    ENV["DISABLE_CRASH_REPORT"] = "0"

    assert_match "Files scanned: 0", shell_output("#{bin}/kics scan -p #{testpath}")
    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end