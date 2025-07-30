class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v1.39.3.tar.gz"
  sha256 "f1ecfa8e91c4a245d6186a8458cf1e9f6ab5bffe6cd83194250f4f862e190ef9"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46fa43448c80211b537799ef5165e7b7dbde9dc38b63f54063b2d3b98c130a38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f6a57025dbf64a394f56ea72de8fb03994b7cffd5a466d7b208480f8aa728ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e94767bb8df8e57f98894f9abfa6317f8b7a6bc982da2fcf3f259204a58745e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea3da6502f6cc04c964e39591a67c1e62df55ec56bfdfa28546368ffddc808ea"
    sha256 cellar: :any_skip_relocation, ventura:       "da490843f52d4a82cf97be6a49c74de62b5142a25cc891ade3f7f6f0f87370b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a8d2b1d03a2d7bb8eebdae372356bfaaf2fb9d0971f8a4981d91d192734ed6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5edf2bbdc92523ff2ce7ddc46ef74ba33e973debea4851b88622a56037cee17"
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