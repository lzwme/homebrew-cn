class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://ghproxy.com/https://github.com/prest/prest/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "a5c65589d3a0ba88cec5850591883f119acd4342bfa00cbbabda51ba2e24b7ba"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4a5fd6b10dbe4ffaf9a2333038b6bc985208057ea00b65ee5214b80f830a9b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93fda84f45129767d98a78fc16e192c7623340276d9c3b3bb7fdc985272b25bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb328120613da249ef2e03ceb1d1560337b7a4e2b94be75aa244358a178998c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff0d6c09e60b08afe103d6004de26bf992075262ffd6c0a02ac441f668781dab"
    sha256 cellar: :any_skip_relocation, ventura:        "cc7299a7ceb856f47be326e0f30ab8ff22f32938e6f2c571513c057cc4d7f7c6"
    sha256 cellar: :any_skip_relocation, monterey:       "8dc9d39413c5c780bde2166b31b627c88c0db0a9aed82827b5fc6f87a48b5286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1763cca675de4a70beb06bebe05c6adbcc689b63af2868e8e9762c00def6ab58"
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