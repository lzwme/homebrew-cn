class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.37.0.tar.gz"
  sha256 "af4b1ad02430f84b48af9a33010318e497eec6a6bfac50954b5413f757224ca3"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e45d07c9fa04550c6328ca23a46ae857f77775c1ae0c614e2d36707402038487"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa67df6f6bb61cea6a80f07294cdb78d72a24da0c489e4dfccb0b455a341b21e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33a5542fc1f36a003c4598b96ad9c0765bf1002cfb7d8b5cac84c2d1ac32dbc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e47aead882b2a462b9e9184c01d1504c9278ddf2ebe1d18cfa66974f79f139f"
    sha256 cellar: :any_skip_relocation, ventura:       "43631d6a1232c0464ac908f7535bd95ddb8fb938ac5bf47b69aaef882179cba2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23d60fe14d0d9246b647a2e3e48ed6f8d40b5597784aa1e6c5a467e79b611d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b8a8720b5b4ab6007df675ca35bae00577da21c0c7dc119c38875cddf43310"
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