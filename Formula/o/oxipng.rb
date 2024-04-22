class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https:github.comshssoichirooxipng"
  url "https:github.comshssoichirooxipngarchiverefstagsv9.1.0.tar.gz"
  sha256 "c6e2d7934b52881fa4b6b71f7e8bce0c32c853d63158fc62b0b079664deb6269"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d179ff5ede44b55ab11e83c98b8601dc215d9694d3228f0c7844f25007b8e44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "589d80d9b55b75bc787aeb87d55c4f0f1465f83df2311fef9f0191fde55841fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fe3bfd213065bcee6dcafe039130bb251efe5049358073b788c357d708b033b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c5f3d80147d6538a7a10489caa715f1a5d187f9b23625787e057e3eaedeae71"
    sha256 cellar: :any_skip_relocation, ventura:        "04eededea1f75dd7cdb20d1e30c58d686e4d69e03bee206262189b417531b1a3"
    sha256 cellar: :any_skip_relocation, monterey:       "bf421de488eef15ffc01433aac733ae69d4a186d33be23eb0e6bd280341cfa91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39e0eaf7d3dd3bf75f72d4ca4f91f459962381858846d624065c1c0756626680"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin"oxipng", "--pretend", test_fixtures("test.png")
  end
end