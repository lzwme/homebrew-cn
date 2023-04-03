class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://ghproxy.com/https://github.com/prest/prest/archive/v1.2.3.tar.gz"
  sha256 "7d44aa11f1e6a617675a5361846f244261c7455c2f9bf4e739a9ca36be1316ac"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e458e3bc43e7df19126f3c45c77b466334fed6c1ac876c7d8b1c289e1adbcdef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39b5ef48b31068bdd8d71067e3bb4a56b53653d2ce4686a1008a69511a7e460a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b64c1417be897c67b116bb79e142fc85119efc137e51134942a7d1701dc2c055"
    sha256 cellar: :any_skip_relocation, ventura:        "b115f8dda78bfb1d547a493a835528e7ad3f51b3846efe52ecc92348aaabc2dd"
    sha256 cellar: :any_skip_relocation, monterey:       "513148459e12b66aa2bad897b8564fea3d36c293030cd7a9b7db22fc8d2f46e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e40513d28ff92b6621361f97e312eb7a165d16f303c76bbc0c958c27bb4ef669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fb3d56658d598701d2e82a9e9094900943a649c2343eb5210250e796562af32"
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