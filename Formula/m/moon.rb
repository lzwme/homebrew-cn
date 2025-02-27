class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.32.7.tar.gz"
  sha256 "cdc3fc04271c611e796950a09c89debf973f3a3155d1ffbf1ca046b4b88573c4"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f55308c63943fa935fc3f46ce77266eea13620af5b10f38ffcabda6c15aa2a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaae6b6f275fc781ce9ec8d59cfbcdecdc48d4e8975e3af61dfea4517bfa7f3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20971efb16f1461e82d29dab64756995747de1fbd16cfa88855908a2c059388e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7fd5d6dd25b11687d386f078fcf46c2459183ab0ace347f9e6f11f7c4d0a63d"
    sha256 cellar: :any_skip_relocation, ventura:       "0ffd4c32e01e276abacf964a9e7b1646823a4a2eeb6201a0ecd9c1430235e063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "224d6450fb54f1ec033d06cae2b06fab0a32428b945bf347eb0af60db37d4ffa"
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