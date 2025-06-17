class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.48.2.tar.gz"
  sha256 "87653524f7f8e9e2c79908c0322d405ab15821ae8f9dabc36ad7caab4a7fcaa3"
  license "BSD-3-Clause"
  head "https:github.comprefix-devpixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dda9feacc96373589268ae8d2856cc50fe8ad03d216ff5c54a5d7f84a4d4b585"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b25992562cef8131863d42e9157945d773ec22767532d5acb5e8cd5a1ebd3f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfe2958a2d2bcbc20236bc3481e7417cdde8cc91ffafdb3d3ee983c13a4cdc54"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b22646381e7a082f0175f984e9c182112f7aec8384cce5b00f05c8c545741ba"
    sha256 cellar: :any_skip_relocation, ventura:       "dbae3ad35ca6ed9fba21c10af14f7313bbcf83e93a1e470cde352d1c8e413596"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "832a8d7979f9d88a89fcce030b63db7df7aa183e793d8ad5b95dd1d9027af22c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dce18360f2f08a68ff31a95ade81deff1ba1e736aac7f2d084de43b52ebc932f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz" # for liblzma
  end

  def install
    ENV["PIXI_VERSION"] = Utils.safe_popen_read("git", "describe", "--tags").chomp.delete_prefix("v") if build.head?

    ENV["PIXI_SELF_UPDATE_DISABLED_MESSAGE"] = <<~EOS
      `self-update` has been disabled for this build.
      Run `brew upgrade pixi` instead.
    EOS
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}pixi --version").strip

    system bin"pixi", "init"
    assert_path_exists testpath"pixi.toml"
  end
end