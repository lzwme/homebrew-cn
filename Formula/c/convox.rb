class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.18.2.tar.gz"
  sha256 "f63799826d11adbcc70525b13b1211ba375ef389898ede5dc57f54b6e2615ea1"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "578e63a769abbb70375b4b7cf097e993b1f843fae87c8f74125f155a0bdc748a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e74a4b7ea2f9afecbb61a258beda8d0be4ba559bed64718e14b47e67fe536fc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6709221a934e8692a0cfc1c866e5d6a6c14e5370af240c4209ca7d22f7aeed9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a50590ee68d964dbbb0e4e294da09f993c2452b0334cb98d606436055f10f366"
    sha256 cellar: :any_skip_relocation, ventura:        "2765f18eedb1224f39424c654723a8ee75e364920525be4ee277d4fa7bfbae62"
    sha256 cellar: :any_skip_relocation, monterey:       "9f964b0fa66f8732a6fe20912f6d90bf112452fece8068b09909c8c5e5e40473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd74cc664b5e81b852892eb16a200d5a34b8dac70414bc6be64d6140ea95a4fc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), ".cmdconvox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}convox login -t invalid localhost 2>&1", 1)
  end
end