class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "f1cc32e7657b0430511a25c95100bb3def168e2912c046045247dd5d58c0ea86"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bda0a60459c6acab6b16ba8bdd9c4a56002c364071751cddf97f3a5a47e04e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e971316932a33b175a4d011f1c917c21e9c3a230d163f51faff1b19a7594f3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4060fecab4688fd415138e2f799a4df6e4fc70c7163516021db6531194f346f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9b5323cd59308278bc402395f8610230a6dec0682db25637ebbf324b610e70b"
    sha256 cellar: :any,                 arm64_linux:   "14ad3cd9bb6375d6c66d9842df5ca02291842cdfaf1e1dc3741d207ae0916a6c"
    sha256 cellar: :any,                 x86_64_linux:  "54bb457176f1946b6fbc3d968bb63f7fc4f006a9ed290b616ccde2d14c002050"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
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