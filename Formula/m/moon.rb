class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.31.1.tar.gz"
  sha256 "b9765213b6b184a8fc1fbd3bc4710a831381ba18384f899bf8861e66a902fed1"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7283aec45766707e1c46450a86e0b902e071660c205be4e5e7f53bbd64cc9461"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47d980695e3096798846c1d264b20f15d4bd3bea798bbdbf6c126fc09a713713"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7ad729e35a85041bdb4bf9c39562192a48db66a76e28f958b057375bda6a3ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb521d2405bbbdf4591e85e6312af2fa9635700c651e04791da8b0f99617c525"
    sha256 cellar: :any_skip_relocation, ventura:       "724be8e6c1df6300f279babc12de560a79313413ae26f5a0ada0d82214419117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63fa44db1338b93b1af1bf4daf5d56192de3b7b2e38c2078bd88f4f3ace05287"
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