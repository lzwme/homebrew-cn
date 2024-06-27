class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.26.4.tar.gz"
  sha256 "ab643c6e1b6e895024a61e7413165544edee14d121a707487a498fe13f69e30e"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56b4e985ccdac9091b72aa92e4617b461e39e417813e22ab4a9f9c9a541672b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51d7a464f9019a7f02141537b6a336bae70cc822e28c74405fefee8d0b66e312"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "218b0070d2758521cba19e0829280ef8f161451284f7845a49e16a0a1764c303"
    sha256 cellar: :any_skip_relocation, sonoma:         "84d5954b561bf2965d50c7a462ac2704fe63a8fd2072dce0814033eef48e83ad"
    sha256 cellar: :any_skip_relocation, ventura:        "4a1a18793d32ef9394d5825cb2e0cefe01750917c144a1c44c9775e39484d561"
    sha256 cellar: :any_skip_relocation, monterey:       "8a65952d3fad39dd7556a1ec9775d58c032b17a783431674b2bb44a99d06ea68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbaa00938083887d2437985b02d3c041b772fcb63bc3050aaba86d0b83007694"
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