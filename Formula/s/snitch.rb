class Snitch < Formula
  desc "Prettier way to inspect network connections"
  homepage "https://github.com/karol-broda/snitch"
  url "https://ghfast.top/https://github.com/karol-broda/snitch/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "247f8fbb13a6739ffbb85db7e4bb5b8110a01e09eb21879cfe543b7e3e6ed6ce"
  license "MIT"
  head "https://github.com/karol-broda/snitch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86c76766e58ecb7d9af842f4b7ea80b7fb3faeab551684536ee10fb4d42d1811"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df3a04d898a39a2f8b370b465e71aa5ddbd448e19b10d4d2698b60ab718ec30b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e5b4e96791869da87a1814c1e33c21719d164aac6948d600bb6010bea0f0a6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d5f86bf487b93430496be9e9f3ae39ab39d5ee9a31e9f89149f64cebfe84509"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9966eec85dc59964a4fbb98166d900a0581db55737955335d4ed87eccfd2b3e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3ac21e8b177b515782bd790cfbc835571079228ac3dd5a7f201d249e7f5e287"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karol-broda/snitch/cmd.Version=#{version}
      -X github.com/karol-broda/snitch/cmd.Date=#{time.iso8601}
      -X github.com/karol-broda/snitch/cmd.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"snitch", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snitch version")

    assert_match "TOTAL CONNECTIONS", shell_output("#{bin}/snitch stats")
  end
end