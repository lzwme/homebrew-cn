class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.73.2.tar.gz"
  sha256 "0770f60db9cd58d0155e4907b7a3a34228f2edca73304039409f76cec4ebee9c"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07f80e6fb3c86b0d4009d7e2e4d0782383bf8144a4ab2fc902ea7d1b77a38235"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf757b1fd6672bdaf6382cc5242a03fab9bf3d5ce3680d2e7da5632c67d3de15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce55f68b3b97da1cfd42722f85066df98496b2c692a0169624232f90855289f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ceeb6f7622889fe7803bbbd8b9d5b97f8bbed93f50d2e335c914b62e168159f"
    sha256 cellar: :any_skip_relocation, ventura:        "e173240f677250b60abc7868f804857d87d5df7b137920c5ea87a3322807a8ad"
    sha256 cellar: :any_skip_relocation, monterey:       "a72785055dd39c8ade8c4bb2a05cfe7f294fb2eb1669e8c3d0dddbbdec5fb58a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2b6f8d7cd3103e1ed8f9c30e2e1431f879ccbcd10574e8e646b7587fd2e5a4c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end