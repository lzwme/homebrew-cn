class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://ghproxy.com/https://github.com/google/osv-scanner/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "de5b5daccf92e39374bed8114cbf03a0079fbee8a3ce9f584b4121eeac658c66"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c44e045d310ab96f8490f0199bfcdb0a304114f061dd7fd1e0536ae19634329"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d2c5e69f8e4a24bfc4195325dc5fba7b3ad2e4fa9968340059c49a2b459d480"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9be46c39ce87e3a48f91d87637e31719eb134fbe389c95f23bb124439ee555b"
    sha256 cellar: :any_skip_relocation, ventura:        "8731d70f821d10024a6f13c24bdf9c2634b1a79b697ce664e225f1fbb3f224ae"
    sha256 cellar: :any_skip_relocation, monterey:       "b8159df11b99815d36960709fc49ab990d8245cf6e8698a4d3afd23dab81d4c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d713e544b19d544412c68ffd014560221f401f9fbb68c13d3f074ae58da6a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca1c653072483791bae31ce476729e163040859ce2b8553f4098b42d85a3a718"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~EOS
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    EOS

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod").strip
    assert_equal "Scanned #{testpath}/go.mod file and found 1 packages", scan_output
  end
end