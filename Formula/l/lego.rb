class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghfast.top/https://github.com/go-acme/lego/archive/refs/tags/v4.27.0.tar.gz"
  sha256 "bd5a07b0cc111e6848d4065581e1da46f1c474db2e32b5e71d9c3f9f7753f303"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5541f2b175ef0e246d73c8d39bcde63ad23afa7eda99ad2c7e47b3a3e8db8e00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5541f2b175ef0e246d73c8d39bcde63ad23afa7eda99ad2c7e47b3a3e8db8e00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5541f2b175ef0e246d73c8d39bcde63ad23afa7eda99ad2c7e47b3a3e8db8e00"
    sha256 cellar: :any_skip_relocation, sonoma:        "c66afcb2dc1b246701266e025ef0af270b0ab66c69dca79f2eb82e46a9983397"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d72aff539fe439d6dd9f1215510ea6a62d875c3eada60d185a8ea6e039f1d72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cb4418f77830f3b0206fb59640259f734d411c77e613820308298341d9d68a1"
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