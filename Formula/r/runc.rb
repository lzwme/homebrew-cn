class Runc < Formula
  desc "CLI tool for spawning and running containers according to the OCI specification"
  homepage "https://github.com/opencontainers/runc"
  url "https://ghfast.top/https://github.com/opencontainers/runc/releases/download/v1.4.0/runc.tar.xz"
  sha256 "f67c16fe40d078be6bf40006b086068951ab885ad815dfe8fa96c0a546aac57f"
  license "Apache-2.0"
  head "https://github.com/opencontainers/runc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c1e65ec050a170357b5ffbadfe188381171a0195900cfcb831b05150ca8c4756"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "00fcd55a2e57a3a121777511457c9ae3ca626a627117e15e89bda428ce293028"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "pkgconf" => :build
  depends_on "libseccomp"
  depends_on :linux

  def install
    ENV.O0 # https://github.com/Homebrew/brew/issues/14763
    system "make"
    system "make", "install", "install-man", "PREFIX=#{prefix}"
    bash_completion.install "contrib/completions/bash/runc"
  end

  test do
    system sbin/"runc", "spec", "--bundle", testpath
    assert_path_exists testpath/"config.json"
  end
end