class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://ghproxy.com/https://github.com/prest/prest/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "a18107758697e12158d800a7d14599a482254e02a41bf53fb68c75a8e6d56603"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16a6ee97670c8ba2698c7cac7e6d56390f87444349b7dbe348abc089169214fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3c52c9a61e237f9028e4163dc83676e9c61d4d21230b7742eed3e320e235c54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86e59ff878934fc6fdf55e6d2538128ae73455ae1c5fdc79fe6ac03c53201982"
    sha256 cellar: :any_skip_relocation, sonoma:         "20c37ce561bf101cfd138871305d5e3db54366f45408c5c8dbd385f41dd7f127"
    sha256 cellar: :any_skip_relocation, ventura:        "645c80c09f3689bee9b11a5ebd2560f018e2e608d108259e43beb0521d8d01bb"
    sha256 cellar: :any_skip_relocation, monterey:       "ce1b12f734364d062d86cafe0e1a6c93ab042e69806595f923c98e8d6e247e11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "110b1bed47e57a338bc94132bad114f94b2753653acebdeed627d9658348dd20"
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