class Pixi < Formula
  desc "Package management made easy"
  homepage "https://github.com/prefix-dev/pixi"
  url "https://ghproxy.com/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "05e991faecde5cf3814db802c25ca44b09cdbe067cadd5ae008026d8b91eba43"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d5bb1fdf87aeb729ddf45e7011ed2c973135d217753b4a8234b3484e4059198"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2adfee511755124c127e27081b2fa87465c6dccafaaaba6ab1fc9811e92cf625"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8daaff6976517bd57edbf47ad335fd8c21070eebb1b4fc509d9f1a9e80bef826"
    sha256 cellar: :any_skip_relocation, ventura:        "361c570320fc1d907010a7bb6b38241601a6b8de13468b04d1eb87ba2057e7bf"
    sha256 cellar: :any_skip_relocation, monterey:       "c485bff2077c48d2052bedb5bbe74c5b671871204c883b941b8d8e97afc1bab9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d98290e7bc41ba597e64dd417d64802c68c0da48627199ea0599822240d7e0b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96afd29f0a58de4b87410c3a9095c0c1959f736d669d7eb8559d0aaba5932bc8"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip
    system "#{bin}/pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end