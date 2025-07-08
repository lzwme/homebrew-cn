class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v1.38.4.tar.gz"
  sha256 "165199c9a8318b470f45133d016a1930eef346df0fea0abbbd7b237e205569c0"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7f7b08418eab95b1bb4e5afdd61482fe9821ea0d37320e00a3976e86ef7ced1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc469358ac65fb9b836b765d6384c6a8120792daef6a5efaed6b58f70632949f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "486d5990ebe7ccf9a36f54f5756a240b9d855d811375c85c57f64872ee5728ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "e58addbbe63aad00c97e5ae4e390f14249f3a6c2c8defa67f82b155872962105"
    sha256 cellar: :any_skip_relocation, ventura:       "45cf2b1356cf8ce9158dc650c25dd6ae84a03e57b04829d3097e095b2b1ee636"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b5218f98289bc2f02edd192cf631a652d6c391ed1f25d78ad8d6f134a5db636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e55796da76ce76fb6ff94f64e1cd851a0faf45836423f31b02718b1e98470eb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, MOON_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    system bin/"moon", "init", "--minimal", "--yes"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end