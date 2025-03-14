class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.33.0.tar.gz"
  sha256 "26c85879372d698cb051736fd390b3190973215c9e55d4a8ed7fe93109dc73e2"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4b76961e372a7168ae4107ef2158d4d4985fa496d8d2df30e9fb5d3f1075338"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a95fc8cdddda7810993542d61beefe6563f13c315b7662ad6d757dac871dc625"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc37e60b759c05984af206ddd9b1e4e2f675c6a312d3b92f008057ab8d86ab86"
    sha256 cellar: :any_skip_relocation, sonoma:        "95f6385f043747a4497cef2f10a4793ec5f780a5c8945d9abb34b16cd28a9d41"
    sha256 cellar: :any_skip_relocation, ventura:       "f3ce2c6bae10e00301f47e9c978dbbf342ccf5f6e2e7c1d2662accf7c6987f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7eabe2d73d4e848ce0b20766bb0810d56b721bb1035475ba3523b6b15eb75ee"
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