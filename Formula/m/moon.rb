class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v1.41.6.tar.gz"
  sha256 "fd54c49c6e032f9f4099af37b25ab76b0def62b94b326a477a57adf1c9154aec"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be12aaa443428b10b9194dd27fc71c8b1be680a916bcafed0dc3e3f8e309f3c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4c4e6d89b04359477fc5f95df2ae2243101ced6ff45e5a801b67bfab6262c55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a27cc6442667541b0f19a8da2c61f92dfff5353ae8a927d41a704f19334e5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2b2ff8ed2c04fac7031cd9574995bbf16d5de1a2ac7ccd414a2e6695db5257e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79b686738fb1239125d22bdd26250010191b343ba2769204aa784adfaffa4648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b27124793f0e3973258c41877ba3ba1511ccfcaf2bb293718ddb326d44a2f7f4"
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
    assert_path_exists testpath/".moon/id"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end