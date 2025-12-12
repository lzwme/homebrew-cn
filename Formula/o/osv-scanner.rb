class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://ghfast.top/https://github.com/google/osv-scanner/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "d5c64ac45206cc32b2ee1eeac7676a32cf1997dd36f6674ce943f4c2c4911a86"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d09732e318e9000d6a337577713eae6303a0f34c934a3644e77002c8724c98ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9039a76b882870eeb4fab347ba54170da2ab0c46b02ac083a60931a338beb59e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa7296fe0500323389384f4ac03f48aa1d5f8c2c99b19878c2fffc8d0108f5cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d358839d2de1d919857a418426ebe457587baf05c6604548b726d055efe109c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e9d9e1c7ede0717bc7e9be4f8ef91208b40f061fbdda620d283315c2634730d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "142b019921fbffbb10289f6cdda05fe337219f5aa441743287698746d19674b6"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    GOMOD

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod")
    assert_match "Scanned #{testpath}/go.mod file and found 1 package", scan_output
  end
end