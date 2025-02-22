class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.32.6.tar.gz"
  sha256 "25c8a8b7c231e67b05432f849864a9278ae81c07926176b6b442ff16b04ed015"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "307c3229a07b53248aa4f5c08eda461fc52737bff2db3477badb601ab4e3e5c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5f6e77bd43825e8682bf9aae3c7b35704398de0d881e9fc874897a46c93c8b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59761fd425b6c7a495b6e12ffbbf2795e155a82eb8ce793ec3769e56d079a5e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "eabd565a2da4a9b4742a66791d7c852cdde91a39ce045c2deecaaaee3c8621e3"
    sha256 cellar: :any_skip_relocation, ventura:       "02f986aab98daaec5dfedacc1cdb86d76aae5f755e2cff271f9f9d8db87eedbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baef43fac7d68db8e5f520177d4ef8fdcf5730540db91988d72e5b70d51510a2"
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