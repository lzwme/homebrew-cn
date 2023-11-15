class Pixi < Formula
  desc "Package management made easy"
  homepage "https://github.com/prefix-dev/pixi"
  url "https://ghproxy.com/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "b2d86564a1c12a03a9e2afeaf73a32f1cac075fb36237ea7ac2f5037aed216c7"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c77e1f1890d68c16a89234837e9bfddc04c518b25c022feac49577c3d821c95b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2997fd96415d1c4f4c99f20c1e11821ef2a751b74ebd1796591da6eb6cfc3d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d0bbe4ff31b851bf45ecb0f526f5785e47d20b3d5f956bbbf13c59a969110fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcd3b02120256c63931005791a529641fa8203ebb4ad6a483813c1ada68e1aaa"
    sha256 cellar: :any_skip_relocation, ventura:        "4e5c20782c7a899376693d3a0bd08a11a04d891b6083fac95f25ba0540067283"
    sha256 cellar: :any_skip_relocation, monterey:       "1b024f04e8f73730411fb0b646cc3a5de150dc1f7c19cd9fb267804dda424039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e26103ce4fc5056c2a8d7636f0ea6d3d21edfde0dba0ce2b60f683db92a58a2"
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