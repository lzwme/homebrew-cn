class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.25.0.tar.gz"
  sha256 "131fb6ee1b663cbed498d1c1dd8c0192e35f7ab95eaa0d05e3db200bd5bc428e"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3ec2c521086c0622224996c511ef5cea48e8c603bcc1410844ba9141ec39f7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dd2bfd3a3678ef9b875e052a2a0f29c129acc1fd71cfcb50ab9cab65fc3f957"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d81cad1ef5a5f8f38d9497ea32a91a44e9f9965fd87c5e5fd23d0758ff6abcb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "e424695f2833a598f198699d3a21052e7e3fbac93bebd689901c1c8136eed2fb"
    sha256 cellar: :any_skip_relocation, ventura:        "8ef2ef461c0c8a49c5a349f4e7ce973ec05026026f083deec6bc26a64aef232e"
    sha256 cellar: :any_skip_relocation, monterey:       "cd1c78da3ffa0a7149f181f80d52ec879924d1a1977c03d079884c2686094b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c227b02357608ef9479436307d1d4d740845539603fc78763332ee02635d20e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "legacycli")
    generate_completions_from_executable(bin"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec"bin").install f
      (binbasename).write_env_script libexec"bin"basename, MOON_INSTALL_DIR: opt_prefix"bin"
    end
  end

  test do
    system bin"moon", "init", "--minimal", "--yes"
    assert_predicate testpath".moon""workspace.yml", :exist?
  end
end