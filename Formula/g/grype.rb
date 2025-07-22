class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.96.1.tar.gz"
  sha256 "0567e9d591b6e80364fa1adcad861d625af6d15a0b7bcf5807ed00e6db7cb56d"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c436aac6adc5eaf2f724d1b1b7102a83ebad57a8f3779a2626ede7ecf4ad8c50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6ab49a30c35781cf900c42047d83df020c9bbed2ca154d036f789f67894a68f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "890c0373049cfcc11852fec6e6f50623830002c607bc09061d247aead48669af"
    sha256 cellar: :any_skip_relocation, sonoma:        "ede2ce1a1c7e0ca39f8e7897ecc3671e56650c9713bd5299d50c6f8058a47f40"
    sha256 cellar: :any_skip_relocation, ventura:       "0c87052d31fa1b18156c6344892b77650ea2451dc56cf483ba7b2f446ebc0406"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3cab586a3be0ade97b9e38ffce27437cfdc8fa5fd9b395bab3d9e6528df76bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6406ae68dfa19a676295887ab03e9d6de873c50f6a67ecd266dd4288cb3af230"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end