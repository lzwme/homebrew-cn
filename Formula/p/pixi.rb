class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghproxy.com/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "1afa3fe799485ca3cb24df487834f6c52ec1b08b8915d39ec6496f9036ae3560"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9085a9da40355627d653077ac934abb8a40accb0a40fff90a4a0e4e067f034c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dabce4745c69951dd9a7b21efffb2d263c95c68df70fbbae1bd688a8839630ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "047ebaee1370f27959b7e1479bfd2b30f9e6f27c0e21ac9fdd5fc89d4cd54a06"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ce36b225ac398df09400fbce5d160a27d3605d49646765ebcaf621bafc44445"
    sha256 cellar: :any_skip_relocation, ventura:        "eb2a1913d164a1003039c21d7b9b2b13f02dc7c58a5c90b592351ecd8c5e6955"
    sha256 cellar: :any_skip_relocation, monterey:       "30a89fb5f49d8ba52ee3a168955d9dc3c7716888d5285dc342586872d466393d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f09f6fdd7b9f8f48b6955f40614e6d157069c24a71c7830467df6f5b5789618"
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