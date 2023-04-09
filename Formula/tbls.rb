class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghproxy.com/https://github.com/k1LoW/tbls/archive/refs/tags/v1.65.1.tar.gz"
  sha256 "109ed230280e16fac7289527a30c535d900b797cbc8cd01d483354cc5ff1b327"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad5416dba8649ac135e936036b527c5d00fcb994b3ac3fe61ca37f61dd68d4d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf3ed7b0dc442ce3df068c6518e3aac665526acb41adf215fe6328378213d595"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36c9fa3ff658b98b1dd511ad0231f2f6c33155e371648ae8efb3d505a9b149bf"
    sha256 cellar: :any_skip_relocation, ventura:        "26187b0e17fd4479d02d357d5c1b4e7a372d0c0b9bf57f39560ee2982e0ab64d"
    sha256 cellar: :any_skip_relocation, monterey:       "b4160f144a4e14bb76214c27e5511880090f4ee736fd1bff197b8f8dd479134f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c97d143095cb834efee55dc469cc6db2fb49db416061bb08f611bebd563d2dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f7b2b9c9d60ed74963a7927c2099d84d917a50e87bb39ef200c376d6db43e9d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end