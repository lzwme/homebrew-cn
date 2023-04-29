class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://ghproxy.com/https://github.com/prest/prest/archive/v1.2.6.tar.gz"
  sha256 "0babff0b7017c07df7d88eae15679c9349796de03fd2c980aa0627fcbc0c7ccd"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0391ae28df0a7989597264a4b947287229d04133c0e29892aa903be127b19ed7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27141e3c811c768735ad1283e0c8a208ca2c4b8969de5d1fa34ee7f5efb05a67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1106ae75513683f24c306d8250f593106de7c70e6a948d81e9b7e2b7988f70e0"
    sha256 cellar: :any_skip_relocation, ventura:        "362c9465a09dc7b01574fd319a7621c8e64a01debc8f37c19c79003d88de60ba"
    sha256 cellar: :any_skip_relocation, monterey:       "9ec4877d6f0ee7ad413bee2d6d3e4b5b1b3fed837d8cea4950bc913e488e5bd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfcbb30c152e864d6890fbf5834bbe3339497e4f272e68eb8778c349f964e71a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "361af30a166f2a5562c5ce190c1a7a6b30931bb9e725370cb96f8da6afb9732e"
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