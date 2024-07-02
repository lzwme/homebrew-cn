class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.26.5.tar.gz"
  sha256 "a51aa15270fcd7646b11c928d57dd58748776eb49b3da594b42610861d480497"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c17596aa69b6ae009edee1e740f7c9ac238ad7a85718f798201a59a01d158135"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f138042e17f2fb6133eeb4a75604af9cb06a86fe0c06c6deeb36773216f15b01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4d32cd32753dbce9d8d5f57b2e1c344f8c3fe1e4959d6e015d5ee62f0f782c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "3226e6f1bc11ec1b6c2774a1a49e4fd73f9224cafd56c658d7a60cc1e3cc19a9"
    sha256 cellar: :any_skip_relocation, ventura:        "8c0af8d6dba2f1b47389a2fd5d2f66990decc05c80fa8817b55de571495451d3"
    sha256 cellar: :any_skip_relocation, monterey:       "475c21ce1caf810a085e6e8a3c57c15ed35fdaa97a549a4ce896db4a64358003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5066652eed6146997d8aeac94104f18ac2cf87229049206244b46b22c0571c2"
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