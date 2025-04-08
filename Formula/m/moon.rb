class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.34.2.tar.gz"
  sha256 "2c94cb3a1a6ef8420ff54bf6a1ec9e24b581f2d8feaeffe19beb6e812e0c64b2"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e31d13a1b235bb47634a9cc267e9838e22505127fafa42cfd3b42d873d2677a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e73bdd450f0b49608c0323a4d7c7d43d22f5b6857fb2c85e54a9626020a5c06c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58e3926e4d9f177e0001facd4cf0fa9d6c26759050873eedaef45156d27bc2fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "2db9640c2cb502f22644cf08ec258f263a8c0108db2115962982f9e23cac49d1"
    sha256 cellar: :any_skip_relocation, ventura:       "a56df99dba22eede779e35b2f1c93c80ef04bc19de93e866ad5418bb8b51fe84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "332d470cd0d794bf6e92adb170d76872c039a16c582822b9a92c152ce5ffebac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c3b148cff5d80088e3d053064bd12cbddb666a68a581944cbcafe94de9d4c8e"
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