class Errcheck < Formula
  desc "Finds silently ignored errors in Go code"
  homepage "https://github.com/kisielk/errcheck"
  url "https://ghfast.top/https://github.com/kisielk/errcheck/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "d16b7757bf57dea5bbcfce42badd1bbfadd4c112b2da90b4ccaeb81c6c438c1e"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea2313fc0835034a5804d0940ae1f208f60db51b4f2e52ef890e0736aa970e86"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ea2313fc0835034a5804d0940ae1f208f60db51b4f2e52ef890e0736aa970e86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ea2313fc0835034a5804d0940ae1f208f60db51b4f2e52ef890e0736aa970e86"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb99a687a0475b506372eef41d6ee64961284e780385738c74999fd3b1a90243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c10998541fa6cf8c4335850ec1b50659dfe2de34bbdf8bfe78b9c893b5dc3cfc"
  end

  depends_on "go" => [:build, :test]

  patch do
    url "https://github.com/kisielk/errcheck/commit/82a8baa1a45a73615d0723ce58e5a617e3c4eee0.patch?full_index=1"
    sha256 "6494c48f4c3246a7af7d8d9d21b247118e5d17f9254b7ffa2e4504a26dcbe31e"
    type :unofficial
    resolves "https://github.com/kisielk/errcheck/pull/286"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
    pkgshare.install "testdata"
  end

  test do
    system "go", "mod", "init", "brewtest"
    cp_r pkgshare/"testdata/.", testpath
    output = shell_output("#{bin}/errcheck ./...", 1)
    assert_match "main.go:", output
  end
end