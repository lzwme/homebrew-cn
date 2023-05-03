class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://ghproxy.com/https://github.com/prest/prest/archive/v1.3.0.tar.gz"
  sha256 "bf4414958afdcabde963a1cae39bbdffc8927c17d45ba98449428c322588bb0d"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4be79ba17d0580039107770f2883ad1855164d3119b4387dd77292d879d3c672"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9ec1401762dfe291c2bb7111ccc34da2329bf0fc77e76808c8bf55dd9f48811"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0184660b40c81e3409611a1b953ba562ff4658cf91908b9aa4e092a3911ad607"
    sha256 cellar: :any_skip_relocation, ventura:        "a09154529b65f83713b051c0fb937f6593097a5eeb8c46dcacadd37824a1fc4f"
    sha256 cellar: :any_skip_relocation, monterey:       "2c73dd6365c0ef077409664791894fb7ab554624aaeb7af6a2b34bd31b332162"
    sha256 cellar: :any_skip_relocation, big_sur:        "f55b56af02cbf9e700a9ee04c26a049178430bff430b81f8984816d469fc926a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db0c076418d76704b8ab09e45befef2f9d04c2dc76bf1e016fd16120c5d91c00"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/prestd"
  end

  test do
    (testpath/"prest.toml").write <<~EOS
      [jwt]
      default = false

      [pg]
      host = "127.0.0.1"
      user = "prest"
      pass = "prest"
      port = 5432
      database = "prest"
    EOS

    output = shell_output("#{bin}/prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/prestd version")
  end
end