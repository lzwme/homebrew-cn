class Errcheck < Formula
  desc "Finds silently ignored errors in Go code"
  homepage "https://github.com/kisielk/errcheck"
  url "https://ghfast.top/https://github.com/kisielk/errcheck/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "f8b9c864c0bdc8e56fbd709fb97a04b43b989815641b8bd9aae2e5fbc43b6930"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0c68d0627e96f81d5c9908e475a382997f174292480d7e401b9611684ccdd1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0c68d0627e96f81d5c9908e475a382997f174292480d7e401b9611684ccdd1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0c68d0627e96f81d5c9908e475a382997f174292480d7e401b9611684ccdd1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9d6b69062cdbb9c8b5edc8129eb5e397807321f74f6b14a359bf33b9aff6fed"
    sha256 cellar: :any_skip_relocation, ventura:       "c9d6b69062cdbb9c8b5edc8129eb5e397807321f74f6b14a359bf33b9aff6fed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "289d849babba526eeb0da09e382a1b33313a8b68010e1b20c78e92d64335052f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ec9399bb316f7bd3d51f053ec6f918a09a7c209427c75192d812767135fa6ec"
  end

  depends_on "go" => [:build, :test]

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