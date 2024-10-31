class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.8.tar.gz"
  sha256 "8272b5bdf5bee3e2c2d8af6ac738cbe8c4e2d14671102c21a55ca6d9fedbf3fe"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3bfd053f3e55542a534c0934646935c8b4a8bbcca7e38a6071d2b3cc7e4863c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3bfd053f3e55542a534c0934646935c8b4a8bbcca7e38a6071d2b3cc7e4863c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3bfd053f3e55542a534c0934646935c8b4a8bbcca7e38a6071d2b3cc7e4863c"
    sha256 cellar: :any_skip_relocation, sonoma:        "58f8d73d4dfdadebf3e9a9594210df18173c771bdb3e373c4bdbd39ead81559d"
    sha256 cellar: :any_skip_relocation, ventura:       "58f8d73d4dfdadebf3e9a9594210df18173c771bdb3e373c4bdbd39ead81559d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1e9975d7ddbf9eec3a16ad16b0e969306cd97e16f7bffe9a91e0097c84c876a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelperv#{version.major}cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}example*"], testpath

    output = shell_output("#{bin}talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}talhelper --version")
  end
end