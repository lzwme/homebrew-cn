class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.36.0.tar.gz"
  sha256 "d9e49d96b947b06802dbcafa3f860a7aeab2a708e96a07e993e54e3908fba947"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a9f2d586534c3cedbcb5934fcfd98132afdab0158df056406ee51ba969b7eda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44b8a0bd1f23e9e335b65bbd53d9f0e001c1b6ebaae3588c30c9c76a27a29e7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70dc639da7c50c79ba2b148350f3b14bb5172b2c7a76036fd3fe2d80cfe92be2"
    sha256 cellar: :any_skip_relocation, sonoma:        "23679eec56f86d90140432b36ecba3f8d38be852205abfb9f113200e15c92c6c"
    sha256 cellar: :any_skip_relocation, ventura:       "3e2d1d1f19b5345eab5640bb27cbda2dc5ba9f218ca07806d135374ba9daee0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97138995c99d7c8d52fbccbaaac1e58cfa878952114aa6861481035737fb6ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7297adc9e5bdd4a6b889358d60bcf7b22a8f7f4c4c5bd9df61dae071d3f11852"
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