class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.23.3.tar.gz"
  sha256 "b8c3fb01d5605cfd8466f0ea978b3c62ceca1e77f40a025ba68299795c95c957"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19528e86e22cd3fcde4c8f48e0a8a7cc4db7595128d003c18f5028e875fcb069"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecd4b0d59c224bacc956281ddd9765fc15ebffa816bc633ab68082e342aac47a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca2761a6a52eff6585c66dc51329607afc49cb2e24fc57fbe37bb9e8898ec495"
    sha256 cellar: :any_skip_relocation, sonoma:         "5553df223949444fb83d40068b11537d5309ed6c96c7607a0a7afb4c386fbb67"
    sha256 cellar: :any_skip_relocation, ventura:        "e9a18dc68e78793964ea234ffb4dfdd057aeb909b071798ecced6c2c3b2bb265"
    sha256 cellar: :any_skip_relocation, monterey:       "bd3c926feeaf44e1cb5a9067423d340d3faffc0e5c79fba4b48b727447423731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb3fc74e08189ce02872d6b993562da8dad9dd20ffc78bd6ff4689141fcc1b85"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

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
    assert_predicate testpath".moon""workspace.yml", :exist?
  end
end