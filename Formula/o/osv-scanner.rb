class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://ghfast.top/https://github.com/google/osv-scanner/archive/refs/tags/v2.3.6.tar.gz"
  sha256 "b1ed2e92011884269eadb244bcce59126d540f659212d6a644c59e0c2c4ecf5c"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cab70e4bc4ad986eef5dd9af55ab4af7ff446a3ec1e9fbd6c4d7ed92a830a60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f039362708f3edd54c56769b3d2bdcb70253895f783d002e1ec170111cf512bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e223b756119cd71da03059ddb8e8fe6729b26c4200fd6df40ef19646a965e3aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "709c5782ccdc60ca57bd51d5ce0a63aebe25061a73db7d23e772b30adaa1dee6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "959fa8a1a71ddbc67ad5e8fcb822a3dc2acdd910285ba9a956667ceb53d54f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "338a279de9c0a1ef502095bff8eccc25e0c1b023dfe4c14069d7953220b2ba5e"
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