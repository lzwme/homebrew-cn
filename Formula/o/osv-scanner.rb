class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://ghfast.top/https://github.com/google/osv-scanner/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "6821d03b0cb7e66e8b1a77acb76d31abce99778e8077ba97b207a9c47979715f"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ede23482c3f262ee7fa7072f58adf25f97ebfd0eda68864bfddc11872cebfc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "977282a3f6d82eaff7863721c6ceeb9c02b88193522d60cb54dd53f9ce87647e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd5568bf1aa19981de4dbefc3649475a59b7a6f6847a6f0793ea6d72a5db8995"
    sha256 cellar: :any_skip_relocation, sonoma:        "c816d1d39ebe5d0b485c4358929a8d860c56b942ede8497926910e048f147a96"
    sha256 cellar: :any_skip_relocation, ventura:       "ab166d53ee826cfc233ac0060376ef2215c5a14fe7be643726817b3b565496c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d20a7709fd5b00134958343e334291915134f329c812165a05b5407b5a90fb1"
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

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod").strip
    expected_output = <<~EOS.chomp
      Scanned #{testpath}/go.mod file and found 1 package
      No issues found
    EOS
    assert_equal expected_output, scan_output
  end
end