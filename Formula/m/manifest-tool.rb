class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://ghproxy.com/https://github.com/estesp/manifest-tool/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "b44ea1c4f26f524e01013356fdcf173df222cb43fb1d48ca28e58f027a15281e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af347bca33b226375b047e77465c387a9786eb96dbb1971cf7ecdb5145c4e699"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3071d91be71cea3bfd5e37b89f7622bf683c9baf889b5088c3bd58eb75a45de2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f5a7007d4baa1a16e699f4b442260122c1dfbb90f4e96c58303c4f47e29bff5"
    sha256 cellar: :any_skip_relocation, sonoma:         "eeb4e36b52181f64c33d762b8a146ac458edcabbb5f3e7f14a4d09b4a121bc74"
    sha256 cellar: :any_skip_relocation, ventura:        "85cf739c0946c83469f41fe4f0489e4faf151231cdf5630f9b7deada0bec3e47"
    sha256 cellar: :any_skip_relocation, monterey:       "6dfbb0ab1943aef18d87fafba0931f9b8a56012d9753c9f76861beef3618d3e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08ede82e74f06bc147c394970353733947a35c70eed1078eb00b97aeadefce02"
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    package = "busybox:latest"
    stdout, stderr, = Open3.capture3(
      bin/"manifest-tool", "inspect",
      package
    )

    if stderr.lines.grep(/429 Too Many Requests/).first
      print "Can't test against docker hub\n"
      print stderr.lines.join("\n")
    else
      assert_match package, stdout.lines.grep(/^Name:/).first
      assert_match "sha", stdout.lines.grep(/Digest:/).first
      assert_match "Platform:", stdout.lines.grep(/Platform:/).first
      assert_match "OS:", stdout.lines.grep(/OS:\s*linux/).first
      assert_match "Arch:", stdout.lines.grep(/Arch:\s*amd64/).first
    end

    assert_match version.to_s, shell_output("#{bin}/manifest-tool --version")
  end
end