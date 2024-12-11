class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.30.5.tar.gz"
  sha256 "163422c7242fbb649154dc77ea22e2a4cb5c22840105e280c2c9eb689173f54f"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bafcde7387a0dbf4c8f538f0439e78db4289fdf824af4214901499e340d3fbb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2f12ea4dc2d726cdc251ed597b3ea2da3affbf1d160659bc3be49cb009428b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31fc0e6301d6b7a0b792ff71871c869f99b1806b910c152a0da84a07e7ca0abd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2aa2564261807bd64fc7f7fafa1a76dc98b668c28e73215968d48685c3481c89"
    sha256 cellar: :any_skip_relocation, ventura:       "fe0710fb5584dae1ef6b627ecba4b5cfaae1bf6baf81016948841fc3d8cd16e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25e7aa5859f1cccd65aa6b9d6e9dc7038d9eb27b0bf94629535570770f3be1d6"
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