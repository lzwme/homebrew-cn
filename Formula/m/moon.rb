class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.24.2.tar.gz"
  sha256 "7d21ba0a15f228078131705092a7c5e06d7514f8dc672eba25319d8d96b1447a"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38d63bfb37444b976c05ea59f651583710b5285ec58d3ec8a9e3387f25bc6e3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "581d0b6c730f8bae2564fe76ed91cc9e54d69e4e25d7e052bde6b7431e00852a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e77633aee41d9df77cc12fca5245b03148e83003cdc4836b7464787b2ee2f436"
    sha256 cellar: :any_skip_relocation, sonoma:         "99d808762d16a01cfc1da7fb6580c74494b3306fe683b24be95bcf8cf18d7cd7"
    sha256 cellar: :any_skip_relocation, ventura:        "294751fb887523f820db69ccf0dbdfe0e9aed00ba4da3f14e0cd70cd0333f001"
    sha256 cellar: :any_skip_relocation, monterey:       "57b8a27aaaf26b90a81752870c399de08e17d27a182a0d30fc7bd5856b6fa493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4f158b2c76d7303ef33d08712c5ecfe6b3c26480f6ee5c5036621a7a546de62"
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