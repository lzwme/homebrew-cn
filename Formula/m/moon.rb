class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.27.0.tar.gz"
  sha256 "3e90160626e0e8d1ed6634883dee46b7bea241b1934f38bff29b2ea1b32660af"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28fb4f0eaef4248b46b3c402c4586174e29df9462849b84ca896097d5904419c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42e5310a6b52efa94a9117b8b07dc86885c41667bea8243955e60187f4d58c4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da1acc7ae9b6a45b39514d2cd1d9643b78944a2e6cce0a6cd1f48fec05e3564c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a16383c4a50470f62694dadd04775eb9cf6c78fe7e969d9c97ebe4ff247b9b25"
    sha256 cellar: :any_skip_relocation, ventura:        "62c44ca3150bd529e4846ec09f08de537e3b0f7d0d1e019d448aa5f276e260be"
    sha256 cellar: :any_skip_relocation, monterey:       "8424741bed55958c7b0f9ae297b6044257bbea5cee7eb521d155545a5a77ec92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60dc6821a585c76fe91920680ae3f773493c90b536f0b3b8cc09fb5e6a13bbe9"
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