class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.23.2.tar.gz"
  sha256 "1a04763fc7e1022c3c1f3fae0802a65e2508e996d25eb0f0bb6d50f71e147b61"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00861a5e7d172815389208b179b334d54bec988b5aec33771559d6359aef93be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3cc36062d4f253e3f0e9b9fd28f68b16ea3b65dab27b87243d2a62bba0da286"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c2dc9e959aed8badb760fdafc9fa38f628c83a20136cdbd42f10ea6ba1910d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cdf57eca78f293b1393a9f515380ef7f2d1377c33179442232b346c7d63842c"
    sha256 cellar: :any_skip_relocation, ventura:        "6f1922be906d4844bc04015bad4dd06442242c679e5c71099203b0eacaccbf95"
    sha256 cellar: :any_skip_relocation, monterey:       "e73c4a228bd56563004f067430e3887bf157fb3208cdd19a2b78e8720369b193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f27886a1d9006d7af481f2a98281ee0d3f4c9fe5130b7eaf8824698ac903da4"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
    generate_completions_from_executable(bin"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec"bin").install f
      (binbasename).write_env_script libexec"bin"basename, MOON_INSTALL_DIR: opt_prefix"bin"
    end
  end

  test do
    system bin"moon", "init", "--minimal", "--yes"
    assert_predicate testpath".moon""workspace.yml", :exist?
  end
end