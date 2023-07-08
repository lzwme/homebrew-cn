class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.32.5.tar.gz"
  sha256 "ab424ed7e0f9fac3fb8f9f2f7d12e9a00303450936ac488fad9f4eff0cd302de"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a65d3ce6f42a9af35bb2331f0cbd0ae43749129823571805b1b9bedb2f038afc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad2248c870647fc6ae66ac884b3d92ee3d11b6df0344553b0c194f461ed0fb4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02b187ea10bba71ef9ce9f711356c11149fb6984c0ed75560169d5bec9a022cf"
    sha256 cellar: :any_skip_relocation, ventura:        "446152a388fb05051ba597402b43d43008234b4000b7d0b7262251907c4ba8ec"
    sha256 cellar: :any_skip_relocation, monterey:       "ddbb35278b54b00ae2a8efb37500a7813f5bb08333a40b878da89b65dc0b16c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "9aa7dedad77ce408abeb31b922094f93fee09eede0a846316d7481e1b55a5c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6323a3c55b789df6139c2b5dc3bd65274559f72ea286b41ad16414391bf69ca8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end