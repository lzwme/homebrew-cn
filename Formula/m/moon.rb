class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.38.2.tar.gz"
  sha256 "71cc5c3346a51b02611e3049223e7750605c75149b9f473b3dcdfd82fd854023"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4a1d100c0cac7b37635aeaaf18688ea1f5bb671f7478c122f6d21e838195b7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2a67fa5efabe5dce1437f21ceb96436c3f225e619c0b4db3a00b42c290849b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b3d4685963fc220502d0e63275ab6b85e757ec097fdd4274763b3b7f0e9dcfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc66fdddddcb8e145d071542d5af9c1adbe65b0e27087c2b9d0d33574c32136d"
    sha256 cellar: :any_skip_relocation, ventura:       "15d8c3f080198326d0cb7640eb48f328605901657de6a4420659372d60f8b9ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1125f1947bcc43aa58a85fadb1890f757483a280d97f44b9cd9f62eb69d6c54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0c79bed6e8b6cbc9435165806eaa3bf3a57061fee92d6bedd46cb247ee8f1e7"
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