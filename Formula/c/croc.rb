class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https:github.comschollzcroc"
  url "https:github.comschollzcrocarchiverefstagsv10.1.3.tar.gz"
  sha256 "3bce38e7d74714bb7ca00791ee9771935a4d2c5dac8a8831b6713f49c1ec4207"
  license "MIT"
  head "https:github.comschollzcroc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "874fa9cbfc46cff2c7afc7351db1b504b0f7a075030ab9bb5a062e055c61dbeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "874fa9cbfc46cff2c7afc7351db1b504b0f7a075030ab9bb5a062e055c61dbeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "874fa9cbfc46cff2c7afc7351db1b504b0f7a075030ab9bb5a062e055c61dbeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6d70f689d835a90fd64e24a4c3a243029bcd1d37158f38e1c2115888c8fbe64"
    sha256 cellar: :any_skip_relocation, ventura:       "a6d70f689d835a90fd64e24a4c3a243029bcd1d37158f38e1c2115888c8fbe64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fcdd0e6f0c4326ce7c2de374b59b51052e488c67f7f9e4e1f00777b36fe09dd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # As of https:github.comschollzcrocpull701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test"

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