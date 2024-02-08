class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https:github.comschollzcroc"
  url "https:github.comschollzcrocarchiverefstagsv9.6.8.tar.gz"
  sha256 "2f44fe7d0a90822908d782de9e7b2341f923a259e833628e1ff514fe630460d1"
  license "MIT"
  head "https:github.comschollzcroc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8840d2336cfaa1b662fe952fc4ff0aebb0a1c35ef4064eec4c16b933bc9809cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50c55cdc6b187c976e8ee239f6c998321be37c65cad690f6a18641ccbae6ffa3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d30409f4c5604117314e85be9d090a9df4d9550285d615921f085d15f70b1ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4853fc9e9dca18f5636f8350c71eaeb12471e8e7c71969d75926a34f5f79732"
    sha256 cellar: :any_skip_relocation, ventura:        "8b79660b8482807707a34cb17160c675bd4a444d7ffaeb29dee2630a76dea67b"
    sha256 cellar: :any_skip_relocation, monterey:       "7a0c5051c12dbcb28391ef5961a24d37e5332494795526b6380fb23ea0f657ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65d3dfa278b855bc8e1607f988f8f9bae31350acc4b4eccf1a1e56d3901ccf96"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port=free_port

    fork do
      exec bin"croc", "relay", "--ports=#{port}"
    end
    sleep 1

    fork do
      exec bin"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end