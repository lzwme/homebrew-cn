class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.11.0.tar.gz"
  sha256 "74dd639b555bbb22bfbd5bd313ec23b3aba22857624148211290d444a6e6dc28"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8997c287c16db2b058a48144945a31d2a56761446fe79d0a85eb5fea55a2edd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7594c1f93cc05fe48836b0911ae2107352772a4db8aca5268f44664031b5625a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2d1da0f814bb83ca03610a5a7831607710d2f653d12a078e9010b51b082146c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4faf6ad9c0ad82f68036bb7af38018d9b6a620cef140dee445b430f7f3508cd6"
    sha256 cellar: :any_skip_relocation, ventura:        "d9f4d4bdbde8fc3546f44f622d8a3ccc804050a50228f47375923a1e0faac32d"
    sha256 cellar: :any_skip_relocation, monterey:       "e4f342f100de869b61cd121c427826a6c3f026dda6c7dd9e2ec5e1901457660f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c84e5f07fca792d1a4be05516039f7605f70fd4b06196f5e3c43244040cb31a4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").chomp
  end
end