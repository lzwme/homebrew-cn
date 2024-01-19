class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https:github.comgoogleosv-scanner"
  url "https:github.comgoogleosv-scannerarchiverefstagsv1.6.1.tar.gz"
  sha256 "ecaefa45c63057a8ebae9fcf9a0b760435c640157516cebfd44237664923ee13"
  license "Apache-2.0"
  head "https:github.comgoogleosv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f150215620f6e46eba2f96929ecbd4236002bcff88fa4786ba784c7a85bbeb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "920fe67c71e2916015f253119b5a6bfdba9c9de382a06542a1c5fa38b1790268"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "735aee2257771809254f917e7021864c9f983765f1aeb8f24712b0412c66d6ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c850def2e97b56ab0aa76241b12126a8a98b8ce39c4e5726ebcfd53ba1bd337"
    sha256 cellar: :any_skip_relocation, ventura:        "52bfc59b1e1411d4bb4fd1c186dd345064169a0ebba34813ad4209ca5277040c"
    sha256 cellar: :any_skip_relocation, monterey:       "06ffa0e2615568aabd003bc6f48e34dee07bc0f78570255d364361072eb9f323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f759bc3dae3fc3f4ae5c83acf1d745bcb9a59f79b6d904d6dcaac2328178494"
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