class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://ghproxy.com/https://github.com/miniscruff/changie/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "2a6a1e3f0756886bcbe1e70b26e6ec961190960e113ab1492f2a7c727350f903"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b097d14d1c774348cc297f74a213d7192a826318f09710b796d4d0bb90067d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "956a64af9d02687c1b3721d0422c282513c59521fb3bb741b99ba934693035ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dafad13a03afaa26e79f4be089181275e559a51348383011970454956297960"
    sha256 cellar: :any_skip_relocation, sonoma:         "af31d0a73042cc2d3c6f3d0dbd1765dc7ec45ff45b6cef9abba0e9e7bd06dded"
    sha256 cellar: :any_skip_relocation, ventura:        "13d633f3c026cc440cb04827b91c7dceaa0ff38641e8f73ac878df1bf71ce551"
    sha256 cellar: :any_skip_relocation, monterey:       "bc4c22f2129b566dab2b8fbc58578b1558498f415037bd9c116f87749a7a31e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edbc5fa134657a0904fc2f34b70e4de4e1f1d0d9ad6aabb0528e1e86fa73e110"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"changie", "completion")
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end