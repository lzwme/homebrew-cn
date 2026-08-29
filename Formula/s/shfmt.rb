class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://ghfast.top/https://github.com/mvdan/sh/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "f193c946e2882c4fa04935cd583f60e2cab60344209bd982a3a5933c4192aad8"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "283f674d188041688dcbc89adede9ed3e1008075e59c1e8452c4620f2c101ac9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "283f674d188041688dcbc89adede9ed3e1008075e59c1e8452c4620f2c101ac9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "283f674d188041688dcbc89adede9ed3e1008075e59c1e8452c4620f2c101ac9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e30e48ee6a087081a05cea304a4eff808a636d5d7240e98e0cf0e16427dae1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46934914e5b8696fa22d0c5046a01d1060ab4eb50a8fbb7bf0ed1e77b96954ca"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    inreplace "cmd/shfmt/main.go", "version = mod.Version", "version = \"#{version}\""
    system "go", "build", *std_go_args(ldflags: "-extldflags=-static"), "./cmd/shfmt"
    man1.mkpath
    system "scdoc < ./cmd/shfmt/shfmt.1.scd > #{man1}/shfmt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt --version")

    (testpath/"test").write "\t\techo foo"
    system bin/"shfmt", testpath/"test"
  end
end