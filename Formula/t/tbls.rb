class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghproxy.com/https://github.com/k1LoW/tbls/archive/refs/tags/v1.72.0.tar.gz"
  sha256 "5aa55ac4e006e724d91066e3c36a30ef0e7f80aebd91f5bea9cced16f4764469"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9a10e0bf945c8b5e2876b104df292d193f8bba6f9665dbf4a15438f07bbf3f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01259e2d020fe90ae3e4908af7aedbfe5aa2f25f7df7a8d26df025b8b1630221"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d11a94eff8ea9837d9e77dcd6532601a090710d5502f666268aecf3c93b99221"
    sha256 cellar: :any_skip_relocation, sonoma:         "80684ff329750ef7d859f691d797fd42b9cf90add385a9e60bea6d7cf2dfc4b6"
    sha256 cellar: :any_skip_relocation, ventura:        "4f0e9255537fd6918770f14a03b8017921c42a8efc2eb7be3764657fb2915b73"
    sha256 cellar: :any_skip_relocation, monterey:       "82b963f708e0118c35f3b12042332f673d68ebbefe624254de163ad4fd0f78c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8448fd56d1f4079046938460c8e5e9fa88fe3dcbbd6ba4a7b4e3ef6b91911fe4"
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