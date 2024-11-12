class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https:go-acme.github.iolego"
  url "https:github.comgo-acmelegoarchiverefstagsv4.20.2.tar.gz"
  sha256 "8b295378d4b2d3fed4f0df6d4d5d6aa712082729334848f89f776a8fec912f97"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc646fcf60cca6b5e069168514074873e22fe500382f6b912929ca92c09c5a46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc646fcf60cca6b5e069168514074873e22fe500382f6b912929ca92c09c5a46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc646fcf60cca6b5e069168514074873e22fe500382f6b912929ca92c09c5a46"
    sha256 cellar: :any_skip_relocation, sonoma:        "d65e9b87b341d672eee6696f1a875b41f2b2a1215eddbb1e05fa4751cde406d1"
    sha256 cellar: :any_skip_relocation, ventura:       "d65e9b87b341d672eee6696f1a875b41f2b2a1215eddbb1e05fa4751cde406d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "262a00a4e48d23d151566d0e1aedb1591b27409b9323b1d893f90a0e55bf28e9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), ".cmdlego"
  end

  test do
    output = shell_output("#{bin}lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}lego -v")
  end
end