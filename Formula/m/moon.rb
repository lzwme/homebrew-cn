class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.37.1.tar.gz"
  sha256 "8b55ad11f05fb6db99d400e0c210dd1590fd9a24e68ce6f391d3e9c68862e380"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0fa35e3bc0854b21d7570296e0a4662cd1ec16c408f0cffbbcfceeb764fa35c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53153088e69be2ae9dd9f244dc92fa4e3f3f8a8aadb58e91a3a69ebfd1acf901"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfd7f8552d6daeec96ca30a2b1b463e9439acd92f5bdad2a0450fb4bc60a2f81"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c064edf73720533db36dc23b0af058cd82d97310bf73778e785042636b81fd6"
    sha256 cellar: :any_skip_relocation, ventura:       "8cde36906f995e0a9d920c1bba86573c1e3592e30f0f1f69e3f86730768ee042"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65d9eb8bd74fc09e90f2d50902eb3bbedd33fbe2e1a795a9f953b8e237a4bd7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29783511364bb3b82367e614b29fe748f1ed58e7fd44e7cb4da07293c255aaae"
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