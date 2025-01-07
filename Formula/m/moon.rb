class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.31.0.tar.gz"
  sha256 "ece0587637e6b30ef106062b0bf31ddbb36ef95fb303f3feed73dfc8956761d2"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c46c570c3b4e30f26a3217dd6fd0e3e8bd6b89dce7c828cddd6d97bc4542aaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87d739ad7efc4b347779ff7c7aaaa6a1c32b9e860d3087c894e847b3c4ea694f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "043ded7b485ed78b0703de76b794fbcc4035a711539dd0fedda647c0513a1bfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2304552607c29527ec6334b90f9c17beeaba93faf38ac874fc6f8913ab211ac"
    sha256 cellar: :any_skip_relocation, ventura:       "a74b4e61553d4f4320650ad7b4691e122810189c9c146e6377910d9d75a4e1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ad23d4808cdd79dec878853a6886790660aed66538e0ddfcefa51ac34a39de4"
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