class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.31.0.tar.gz"
  sha256 "11354fb4ec55498d3138b3280d1b64f8fb170f916ea6368657f60e6e73dccd05"
  license "BSD-3-Clause"
  head "https:github.comprefix-devpixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52bc0714e5a0cf9769a31cce02c98137ef968c5c63bfbd3fa380851f0db3f29a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5367f8c3457e04d6f6efc51af615290b03c2cd156ab03d17c4da8bff31b99c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bae4e925acb47d6ee81db991a6834c357265f2f04e17bc97f8fb82fdbc9b80f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "34fde24d46cb6a14d0a1b7d6fa950d71aa3ec2fab3be1cb03c964263b8c2316a"
    sha256 cellar: :any_skip_relocation, ventura:       "1bb19e336123a6664ed12131e5b7eefe7b5488a0edba2b704304ade4a3752d6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dd07be2675c733b46622dce770a2f76fc3465bc11e02fdbe80d7a341154a82c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}pixi --version").strip

    system bin"pixi", "init"
    assert_path_exists testpath"pixi.toml"
  end
end