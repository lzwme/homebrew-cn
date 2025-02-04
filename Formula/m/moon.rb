class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.32.0.tar.gz"
  sha256 "bc4d37f19b0c2f17ce6d27be0fee5cf562b66e0b2ec1d3912efcdf58f2fb84db"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f9ee1ae03cef6681713d7d69c91c951b019d98f42e2b7448d638ac4c7bf5be3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e26ad07c923acbd860b63589554cd5842e1a6a572d705415489c231cc47125c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65d916b8cff2c2911d4d701992f5f0d8809addb9f6b12847f4455f31ec0679eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b33bfa64b289dca2dcc074fd1b6a5e2a37d1b3b5abb457469fae9aaf021328cd"
    sha256 cellar: :any_skip_relocation, ventura:       "152be036ae39a1ef70c88bbf9741679e7dce28695481ccc9a99af31952d1679b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b318514972e3129840ba2b75477a78bfcb62c90ca422eabd5f52bc4a5b86be0e"
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