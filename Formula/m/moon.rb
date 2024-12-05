class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.30.3.tar.gz"
  sha256 "66dd51daeccf0e27c7aeb251c1788e516fc0a8b7b8a3514797f0c8ca6226b68f"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4730f9b11e70ec4bb8f36aa78a287d2a524225c9d86a0f175186e49e7a62ac30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9330391242e99350f9f70be85260af96e947d2b4e3f69080bdd1d719b8516bda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3859f0c8c2f90cc876bfbf6da213de2cf1f5f8329f7f24837f9c168c087300fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "f10120c73a14089879f43a47eef6afcbf932566d8626a1e06dd20a8cb257c111"
    sha256 cellar: :any_skip_relocation, ventura:       "ecd757362a5cedcc7c250b390b3ab294e70c9538c6355177f5f2fe15d32ad8af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acdc8e729fe86f000c345f789e8487f8662ea2452f2990f37b87486d63e666a9"
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