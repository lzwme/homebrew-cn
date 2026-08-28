class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.10.0.tar.gz"
  sha256 "66ca74e07e284a9047aa1f58c26d0c2b6631fa7d9e4c4ae86e9db981c337026f"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8bc997616c858c2615fe1e30cbc871d7a652e124d469832c9f55e2774e2d54d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "880a937a00964cf5bdc7235f1dfcad96161fb5ed2276b2799d25d4ce0c0c7571"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44cd19bc4d8839dbc6b0365ee2ba098e4db3d8174e655809d0ee2f78829b0eb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd1a371a5727f9d8ffd26547ceb98e560a5b0dfc54d3b518a827d382926b6d20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fd0558e8ca348006b49c319b7b015b1f53ceeb61d719ef204d8a109b9c8652c"
    sha256 cellar: :any,                 x86_64_linux:  "7b4ee53e0ee025541cd01c6275676166048b8d0ded38f2c865bd2565e0e62f3b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end