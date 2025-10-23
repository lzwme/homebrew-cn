class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghfast.top/https://github.com/k1LoW/tbls/archive/refs/tags/v1.91.1.tar.gz"
  sha256 "bb47308a1f55081a8a45ed4209c805b743659d0382d9850d17338877b9af0919"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d6044b674a42d41826a22168d16ab54419d32f50d074d0c47d47492c191662e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eba266962cdee3ca742606db1be718b2ea664d4dd9502b78cac69ccf2a2562b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c614febecb67ef18ed6b130d210bbd294f74d5bf0f00a6132148cabb568e5f15"
    sha256 cellar: :any_skip_relocation, sonoma:        "b532a520c37d117071a0014d7b11418311873a338e2fbcaab4ba26880f7788a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4b07ce8a8ffa283791a33122e97cfe0ddbdd0960b3da29968c49524278b344b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0757e4e3e9d3d5fc6473b6dc5a692d36e9fcd51d8c6e1ff7ea0081de1bacfb63"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end