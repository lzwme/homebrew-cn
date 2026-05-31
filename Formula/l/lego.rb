class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghfast.top/https://github.com/go-acme/lego/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "2e55b3b5b317742c3d65748e69546473564871bdc894302033678edbca201829"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d6778e8ae149670130a8e9b09d26761413afdc8ce779f724c1734b9a29f12bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d6778e8ae149670130a8e9b09d26761413afdc8ce779f724c1734b9a29f12bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d6778e8ae149670130a8e9b09d26761413afdc8ce779f724c1734b9a29f12bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "725e3956e2e9a089d41eaaaf6a92e6bc6ded1a20a2a8c3c201e11a96c99817e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c994d5b09e277e6402b4bfafb41fae7f20931a45143fa86c976eaa315eeee07"
    sha256 cellar: :any,                 x86_64_linux:  "22b756333bad80ac4fe1dfea19a3409608f84f6c13b8a23c3a97eaa34fb3d827"
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