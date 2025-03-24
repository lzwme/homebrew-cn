class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.33.3.tar.gz"
  sha256 "1d47dcecf36d7e688fe078731cae0d8e8044e758fae86aacc40a8a496cc5babb"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3440fe6bb0a61c0e72a4fcfdac3174750e2b6c9bc750ec448bb0a8d3b4cc1edf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4caaa6da5c3831c4613a4055ce7a472b69cabfbe59aedbc374ff43ac5a02f3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27816ee2af81259b8a5a6b51a865cfdd516d42f6a983e270a25e8e39f216cd29"
    sha256 cellar: :any_skip_relocation, sonoma:        "058b9d79eb6e3042b570f8f042663a243ebbe7765a5fceca0fa999a694639704"
    sha256 cellar: :any_skip_relocation, ventura:       "2e14f7c9ffd4a80b69ea8bdf0e06bf05f4dc5f61504b98b959bf8241a4a773cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "481890a2499d02f5614a3b93b7ae0d6609216a84b8050b41dca1e182fb1eb707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "725db6eaa3d09d371ce7bc860d68bf3a6e82837a448e03b0fb1601f4af2549dd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

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
    assert_path_exists testpath".moonworkspace.yml"
  end
end