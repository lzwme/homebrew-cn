class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.30.6.tar.gz"
  sha256 "7c834be9fe44233875749f704de06faff08dbc1abce7234bf127c6b1a004c8e4"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0e207f55e6423f3d4ff647831f80c3c58b9061864ba373536a573c9419bea35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de83198964975b6ad771cd7b4a2c570bf4dc7ee600c7d10f6d558199a03c454e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "003aebecbdb149edf38f40133d4e01d405b754f28f79f46182370d06ffcf9bc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "61ed89a8d116ef34fd8c2468397b11f30459d3871af3fe762065ede4ef78f2a5"
    sha256 cellar: :any_skip_relocation, ventura:       "12c6cbe3a75cfd5c53a130263f41878d662b30ca4283e28a945b3e7e0f44364b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2043ef4aaab6ac302f66060f926ad7a0462d10c21188ae1f0a75e3c931f71bd6"
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