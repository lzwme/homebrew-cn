class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.28.0.tar.gz"
  sha256 "d78094f437b84bff4d17c5552b9af66fe735e82809cf3387c9a91b2164e25dc9"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bffc836d4e8a642188f5564629b1a8166a2e51929e4d95cf6fe9554a30e759f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4d4be963316fbe0c58d92b165e417cf47ba438e733ce2e352515bcb121e1759"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b33c669b9f99dab59ade7b89440245d2002968162f9ab2b86d31ed1efdfe85b"
    sha256 cellar: :any_skip_relocation, sonoma:         "934e1727ef22d7928c2a69bdc5380df23471bbd05fd18414b579853662847472"
    sha256 cellar: :any_skip_relocation, ventura:        "5d6e88f0faf6b06763cd7c0df029400890e9bfd96f90215139515b6740b11aa7"
    sha256 cellar: :any_skip_relocation, monterey:       "03d34a6d365c51810f12c57c14c93f4f6796f3b91526e6b0f83daa16920716ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a50cd0b58c6d955f1498a37e31d6fcfa9dd92bf155873a8578d24fce4a122b9"
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