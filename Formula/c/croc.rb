class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https:github.comschollzcroc"
  url "https:github.comschollzcrocarchiverefstagsv10.1.0.tar.gz"
  sha256 "0968f28c0d46ff181173ae1613aea5c55757384e3c1358917f78bf0ce595d151"
  license "MIT"
  head "https:github.comschollzcroc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19876b54aad244fed6c8558efa6c1f9263bbbaf0efd58e88673c7acbae9e2844"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19876b54aad244fed6c8558efa6c1f9263bbbaf0efd58e88673c7acbae9e2844"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19876b54aad244fed6c8558efa6c1f9263bbbaf0efd58e88673c7acbae9e2844"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2fbf66123103439fdd8322b56f2b30b67512ef79ffb497b991092e4126cdceb"
    sha256 cellar: :any_skip_relocation, ventura:       "c2fbf66123103439fdd8322b56f2b30b67512ef79ffb497b991092e4126cdceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86a0309d1f4be5af5d90f5509875bb4d9856a7f06ca1945ff81f85142ca7cd72"
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