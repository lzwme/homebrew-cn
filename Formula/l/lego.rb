class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghfast.top/https://github.com/go-acme/lego/archive/refs/tags/v4.30.1.tar.gz"
  sha256 "b197e7c6d2fce0b125f7d2a69a7ae38ede095ad3d1e575af2e65a8ee999683f6"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d305bc69816ae5f9b1c5edb2ec954b0a56b247d881c4c405e3d21a22abc88d86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d305bc69816ae5f9b1c5edb2ec954b0a56b247d881c4c405e3d21a22abc88d86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d305bc69816ae5f9b1c5edb2ec954b0a56b247d881c4c405e3d21a22abc88d86"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbeabb3f742512a97db7391aae000fc70ac13b855877ac8536d5306ebd443521"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c4beadddf5e69105645f65c5cea218d48defd091f777696bf028e3be63cb692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22452de9e3f0b8b469a594f9080e12068c47683d00c85a4c2b615943dd2350e9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("#{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end