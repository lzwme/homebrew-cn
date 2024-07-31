class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https:github.comprestprest"
  url "https:github.comprestprestarchiverefstagsv1.5.4.tar.gz"
  sha256 "fd08297be3aa5a3d21a88e152d51ebb9bf0a4c11ea5fcf685288a328efc71b5f"
  license "MIT"
  head "https:github.comprestprest.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e82b839df4a78750884160e360160a2df97c8ea6e1f6125d079ee810492aa93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b893a352b59ffb82da3a765195b3313de9eede3251cdf098e1355d6f31112d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e7187073ca96e3ae66151de21c718b5f48a28dfafa46217b4678ff9370347ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ce3cdc65af76074a2383499f46d1491c3851635ce24456f36fe481425d13aeb"
    sha256 cellar: :any_skip_relocation, ventura:        "e4f1a156209933c3dcb7c21e01fe19545afe445eb75a6fed9c2aad0104407ada"
    sha256 cellar: :any_skip_relocation, monterey:       "065462a2593bfbf7f10b38a6887c66a23ce0cece72d594e02beffcedb3ab03f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b31c007d3b2c304332187ea5e2920d89b0d3a2d39a263752533e58df2185b2ce"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comprestpresthelpers.PrestVersionNumber=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdprestd"
  end

  test do
    (testpath"prest.toml").write <<~EOS
      [jwt]
      default = false

      [pg]
      host = "127.0.0.1"
      user = "prest"
      pass = "prest"
      port = 5432
      database = "prest"
    EOS

    output = shell_output("#{bin}prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}prestd version")
  end
end