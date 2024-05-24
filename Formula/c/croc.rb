class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https:github.comschollzcroc"
  url "https:github.comschollzcrocarchiverefstagsv10.0.2.tar.gz"
  sha256 "deb147ec040925a16fd5751df08d4b54ba544fd80cdb54e272a7c55c327de11d"
  license "MIT"
  head "https:github.comschollzcroc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75a36c27b79e633c1383453fea8ca3d2de0f8cadf3c69487e0361d4879a08b24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a67bd85a65f1a11a6f439b62fd5f67f2e64cfc7d09bbe83d7960586f1eed2076"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80e9c45c761cc615801fb59ddcd389d37241f3f8973a64d9f00df8f505074313"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f28a4d81dceb5dc8a636a0e6d9f0e25ab2801c113fb9d18e2856c81c116c7e8"
    sha256 cellar: :any_skip_relocation, ventura:        "d250b3a0451a0c79fb6494fac70bf630d090fcad49b1569a363bd558b40bff52"
    sha256 cellar: :any_skip_relocation, monterey:       "c251384d22720a2dca48f04eed7fa1a9b93ca51519d8a10031d9d3b5d84aa170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e34ff9c78aa7eaedfa16931e1faf0fd7ab436552c41925df947b0865b67032b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # As of https:github.comschollzcrocpull701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test" if OS.linux?

    port=free_port

    fork do
      exec bin"croc", "relay", "--ports=#{port}"
    end
    sleep 3

    fork do
      exec bin"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 3

    assert_match shell_output("#{bin}croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end