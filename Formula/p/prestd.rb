class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://ghproxy.com/https://github.com/prest/prest/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "91c3baeea7be0ba31bb9e68d5c826f319ed9fe8204b79753be03b77d3334e82c"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17017dd563836bccd0a88514a89b83fd3f33a568082c059a31e30af67e0bb44c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b54f1a69c4931fb9db01cecb416791862374203df5b57aed1f27426707e1eea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d6db7efa2cd30ea724d86c7d30fbc8851f33176d25a7ee2d406e3a5ea2d8b35"
    sha256 cellar: :any_skip_relocation, sonoma:         "964d4c44d1b00c4bfccdabdf67fc26bab874df4de581802c026826dbec27ce20"
    sha256 cellar: :any_skip_relocation, ventura:        "c1aeb3cdbeee2ebd6d441aadd1c319e4a843c035c304bbd40f131b716a3c0212"
    sha256 cellar: :any_skip_relocation, monterey:       "cf29dc57e7ebd2a087288a31320cd7d63a66da677b5ad0b44b744b84f1e158da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4955c8dbcea74071c7f04e2bcd20e8db2e351f5d5df5bcabe35bc93575ebc253"
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