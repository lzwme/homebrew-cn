class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.25.2.tar.gz"
  sha256 "885a2100b0cad6d32d2453cec8dac3f1f002c44942a1d24199b1cc360708e271"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac0b2cd4bdf87236026009f3af060e828ccc42d2fa8f9a75dcaaa457269c73dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c1f4d3c626582ac1c3961e1cf4b32fe4f3b93933baee909cac375e21aafdebe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "722dbbdbbe37dd8f591e62b9f1eca64a915986fcb1e2d8efb802edc40d00e9e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "84fe823f5b84be7f8dda82e8cbadf0ab226fbf6056fd0030a43b4ef37d19780f"
    sha256 cellar: :any_skip_relocation, ventura:        "626585f7b70a87815537ddac7a58a7fb7133cb82cce6625ff73d4e10d29aa6e1"
    sha256 cellar: :any_skip_relocation, monterey:       "a5f91e306828565473ba63e38a84ac2e94bd3e965a027f42d22ce70478942bf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "254189030f2f91f44d77f8f7ce02cbe61d7c9d41b6f83816f38e7b77f152459b"
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