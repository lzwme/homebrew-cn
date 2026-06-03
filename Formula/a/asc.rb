class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.9.1.tar.gz"
  sha256 "6532b8bcfe89f06af347fe43c845be82e280f5ef262fc5f8870e01f39de40c97"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc571d721d2f80561c27f1a6d9e693630e246f8df12867d037b204caffaa0fb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8562e3ca365a09f9981e13714ac78186ce428968d7089f4e1931f737ba3edf62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa1705404160729886571807ee3cf409797f20b88a0bb5ecc66eb77506193d73"
    sha256 cellar: :any_skip_relocation, sonoma:        "62b81f283f234fa2c3854d4d966a1aa28656f3ecf2f3d9ee8fee22182b8c25ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62908bea6fbd7ab2df50029ea8ffd867223381cbc795a3d7278be02d77f3f9d7"
    sha256 cellar: :any,                 x86_64_linux:  "e4eb75d395bb5e2c3c3fb71055f8682b58098c38d2581877d97dbc85ac74fe31"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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