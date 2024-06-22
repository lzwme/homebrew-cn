class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https:github.comgoogleosv-scanner"
  url "https:github.comgoogleosv-scannerarchiverefstagsv1.8.1.tar.gz"
  sha256 "f734d2263f34975f6eb2d39f8457d78d55d8b302ee32cc3cb6e3ed513c7bfbb9"
  license "Apache-2.0"
  head "https:github.comgoogleosv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dad022df39bd7e0a8c7696b66891720e5e84c9e370ebe1273317392654fadb5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0957aef932aa98091d8bad85ca5df7d0a17ddf3410bdbe547ee127fbf9c11172"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdc96b423d1d456fde47ef94b9e8e5e8e8afc1df1ea58104b3ed2360913d6278"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d22d2072914d85cfc0487206885a99809a0fe0ffc0435c7378b0cf6b12eb3c2"
    sha256 cellar: :any_skip_relocation, ventura:        "db7fb9a1b8ba9719745163d532746f815d25c80fc992c2a5ae929ef05b73bb70"
    sha256 cellar: :any_skip_relocation, monterey:       "9fe8b3226e2e654cadec2a8dfdba09e32bf120f2ea189e282a0631f8bf9e9377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f01d44894a90775185c0dadff3620184d213c79d7e6aed73057869df086a292c"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdosv-scanner"
  end

  test do
    (testpath"go.mod").write <<~EOS
      module my-library

      require (
        github.comBurntSushitoml v1.0.0
      )
    EOS

    scan_output = shell_output("#{bin}osv-scanner --lockfile #{testpath}go.mod").strip
    expected_output = <<~EOS.chomp
      Scanned #{testpath}go.mod file and found 1 package
      No issues found
    EOS
    assert_equal expected_output, scan_output
  end
end