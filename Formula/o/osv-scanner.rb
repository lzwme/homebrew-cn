class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://google.github.io/osv-scanner/"
  url "https://ghfast.top/https://github.com/google/osv-scanner/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "466d25bf7ab38a9f12d3d15ab0b94432c45849ac91580caa8475bb2ae41faa93"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b7269f8d1f2eb8eccee8baa1734c84d7e75d7db50667a6b30cc467472418a31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33553459a536123704d4067912095f76d2c7b5893c9a256bb12e4641bb9a72d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dac3db19d72ce591bdc5e6b4fb90a84bd995904ea5d5010445222e1f928f1780"
    sha256 cellar: :any_skip_relocation, sonoma:        "8af4733e4857138ab861a9034f141b77c6fdcdfb108af3c254bd1599906b8a30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6ca56abd6f4109afe249c1612c0d794c4019cd21a1bf5609a1114e5d8e6fb98"
    sha256 cellar: :any,                 x86_64_linux:  "8c69fc06acf86abd0159b696065d34c70713aefcaf93e031f45c7c46adf4c73b"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args, "./cmd/osv-scanner"
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