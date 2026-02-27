class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "bc1cdf8f65e697dd06e6cfab5b9d767d666dac40e40635bec9162677fb7f70a4"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8516f662ffcebcb1061aac567e7be44adcdbada60c3633c427711a75ba9da402"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ed2019abc7e29cd33da30e779139004a5ea7377a285cc93be84f192fc71937c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d394b48d9721c3ae8c0f8505ab7b76ba5c931dd4894bb95a0b5e21ab71ea9d53"
    sha256 cellar: :any_skip_relocation, sonoma:        "64f210d855e545468d98921e190f4426b4596ba7fab6f86d0e1674e37e146cca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80ccfcac83f9bcad0772827f98becf43a848d2cae630a63c5038dc5ed9456a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9ff0479f785a4947bbca4798ba49c4100a19779879ff60140e7b1cd1df2bdb5"
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
    assert_match version.to_s, shell_output("#{bin}/moon --version")

    system bin/"moon", "init", "--minimal", "--yes", "--force"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end