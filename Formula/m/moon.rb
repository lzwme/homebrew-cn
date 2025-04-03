class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.34.1.tar.gz"
  sha256 "177f9dd0aef7c246434c6e54023db02f0d4c16249a94b1c9899770d7fe1fabe2"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c51430caed541b2289f7a9888b80f50a78a645b4837c9c4e3b0abccb423dc6d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5fa50bb9613c2659b0e7cdd422f78b516a50c7a2941f76c1438dc5596612e3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b376b004d95452032f8ddb16a033d4ef836bce4a7c5c9c8cdbde5efe5b03669a"
    sha256 cellar: :any_skip_relocation, sonoma:        "42dcf13817211cf37da7ca2b20f8881395857596a8ae2d8a58097f3670e9143e"
    sha256 cellar: :any_skip_relocation, ventura:       "525b59abc75a578af101b6a33c65f40f8d04320d62e19d4e9ef231597e4f8e1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0acc2ade1541c882312c3755455d7fa06d30df8271db6fe5708e4ff8da010f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "195cb8c49ad3e2d83e05d3b2223ba7ed5a170077117d123333d49a6a630167c3"
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