class Runc < Formula
  desc "CLI tool for spawning and running containers according to the OCI specification"
  homepage "https://github.com/opencontainers/runc"
  url "https://ghfast.top/https://github.com/opencontainers/runc/releases/download/v1.4.3/runc.tar.xz"
  sha256 "13b8b214419e26466a2e0802a098f0759ef2b942880ec242786338b3b7534445"
  license "Apache-2.0"
  head "https://github.com/opencontainers/runc.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "f332115994fdd0285145203ac1fc8c98a1a00e79edd3d9b72476b1d1c58fa483"
    sha256 cellar: :any, x86_64_linux: "b20748c6bc732eeddd48a755dc829430f00cd140314691681f920a6f8e811c3d"
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