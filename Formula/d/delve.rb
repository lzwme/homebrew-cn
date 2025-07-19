class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://ghfast.top/https://github.com/go-delve/delve/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "2fc5fb553ff09c368d5e1fe6abd7279389804d75ad7b5a0fd053138049ecd968"
  license "MIT"
  head "https://github.com/go-delve/delve.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa80aa92e824ed43330096c728858a71a0b33d5c739eeb821b9dcdc4d4fed78a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa80aa92e824ed43330096c728858a71a0b33d5c739eeb821b9dcdc4d4fed78a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa80aa92e824ed43330096c728858a71a0b33d5c739eeb821b9dcdc4d4fed78a"
    sha256 cellar: :any_skip_relocation, sonoma:        "688d6a3e9fc0c62f7d07041022890269b7677a4c1ef911b2b0f5f7d4b6e72750"
    sha256 cellar: :any_skip_relocation, ventura:       "688d6a3e9fc0c62f7d07041022890269b7677a4c1ef911b2b0f5f7d4b6e72750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74cf46b735bc6d3d3da32cb1552d5d3cc715f0514cc62c448bd3937ebdbc416f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dlv"), "./cmd/dlv"

    generate_completions_from_executable(bin/"dlv", "completion")
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end