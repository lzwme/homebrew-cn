class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghfast.top/https://github.com/go-acme/lego/archive/refs/tags/v5.0.2.tar.gz"
  sha256 "453efba56358afbd3618002ea2b79826f8f5a923ad36a054c0b30c238fe9d44d"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "377641a7cdb3b5236e34e0c833786f399239fef25411ebcaa2032a7b7f0835b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "377641a7cdb3b5236e34e0c833786f399239fef25411ebcaa2032a7b7f0835b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "377641a7cdb3b5236e34e0c833786f399239fef25411ebcaa2032a7b7f0835b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8f975853bf588f967c9ef3022a51be1127423d83bdc88c2befcb38bf19f73fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fa192891258dfb6b0513a75c417cafb679ea67d821f895d023ed11f06b3b5b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "480fdc4a4412c18cef2c811d31dac8841db0df4dd903df7e2b3dd32c5f141822"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1
    )
    assert_match "No account exists with the provided key", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end