class Eureka < Formula
  desc "CLI tool to input and store your ideas without leaving the terminal"
  homepage "https://github.com/simeg/eureka"
  url "https://ghfast.top/https://github.com/simeg/eureka/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "b9eb7d49b51341976d72280a7edb8857358ef8ec3715cf4f26da12420622c85b"
  license "MIT"
  head "https://github.com/simeg/eureka.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "826717f726c803fdef26a873db26395cb81014df82d595a8b49bc0927f456977"
    sha256 cellar: :any, arm64_sequoia: "a23b5260da8f083b577d1f0f846abdd1819b7c3f4bf8a70ccad31c5de4abd359"
    sha256 cellar: :any, arm64_sonoma:  "5b40ddf0db4ce3dce13efebcc2c70dd27548cd07c60f541276dd23e722f8516e"
    sha256 cellar: :any, arm64_linux:   "6866da3bef018897c452a74157ea0274384bffbabf297a23b8b9fd49d7e0245b"
    sha256 cellar: :any, x86_64_linux:  "3285a50b65d13c2fdeea4394192374ea2cafa4c0847346b6141fda31e08a4c1d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "eureka [OPTIONS]", shell_output("#{bin}/eureka --help 2>&1")

    (testpath/".eureka/repo_path").write <<~EOS
      homebrew
    EOS

    assert_match "ERROR eureka > No such file or directory", pipe_output("#{bin}/eureka --view 2>&1")
  end
end