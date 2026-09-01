class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghfast.top/https://github.com/go-acme/lego/archive/refs/tags/v5.4.1.tar.gz"
  sha256 "71eb5342f42d3b65002a5ef4c0a2f65889eddaf23bc270814b10f22578139e73"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b5710097a8841f0d8ef9b322bb4655a7bfc45e36ff699c58c70e5fdcef3f31c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b5710097a8841f0d8ef9b322bb4655a7bfc45e36ff699c58c70e5fdcef3f31c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b5710097a8841f0d8ef9b322bb4655a7bfc45e36ff699c58c70e5fdcef3f31c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcf58d14274752517fd5666df37277b27001e2dc3b60315211de4ffbd7fbc7c6"
    sha256 cellar: :any,                 x86_64_linux:  "587d9894a2b3ce423b05643128d75dbbd7e5e49ba7e97cff9b67dd1fd78f4d22"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
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