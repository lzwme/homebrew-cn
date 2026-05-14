class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghfast.top/https://github.com/go-acme/lego/archive/refs/tags/v5.0.3.tar.gz"
  sha256 "6b3ccb20ba8863a2ce23f70d832bded56fe8c28c2d45c6e8da62a75881f088e7"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5909769a2827cf6c3138b9250c350e29578e7812593baced0598318d25357d91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5909769a2827cf6c3138b9250c350e29578e7812593baced0598318d25357d91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5909769a2827cf6c3138b9250c350e29578e7812593baced0598318d25357d91"
    sha256 cellar: :any_skip_relocation, sonoma:        "3414631056cab953d13e33be25c911d45d1f518e37b10fcaffb7920921dbacb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a06f5017b8dec0bef35084e3e8f00c6fd883be286d758b4ab41ba0b2af203ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b61af435db5e049fc2e447db56380f4a6749aab6104dc17c87a99506d04a8d49"
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