class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/releases/download/v4.12.0/LocalAI-v4.12.0-source.tar.gz"
  sha256 "6f874ac69135a0b0d81ae93461650a472241d4cd2b17a5cab7e35c8b6732e860"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d2a4ee1ebdaa3bd756114b3caa1deaab5e9deed1a1a81360b4958771ecc2f5af"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2fefe3c0bdd7f1cbc2f5a394fbf3212bd711b69982e073e980a6533dc9865e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a6cbc12433b83618fb5d851ab83c9f069ed77b4df5291dcf505255bd7165178"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b4fd2fedf5e8dda4e9abc15760b1f85629ae03bd64e3fff087e4faaac63fbca8"
    sha256 cellar: :any,                 x86_64_linux:      "c05752f03f9e09048da54806c278753e4d24698fd0ef68c6853207ce6917c366"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "protobuf" => :build
  depends_on "protoc-gen-go" => :build
  depends_on "protoc-gen-go-grpc" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    system "make", "build", "VERSION=#{version}"
    bin.install "local-ai"
  end

  test do
    addr = "127.0.0.1:#{free_port}"

    pid = spawn bin/"local-ai", "run", "--address", addr
    sleep 5

    begin
      response = shell_output("curl -s -i #{addr}/readyz")
      assert_match "HTTP/1.1 200 OK", response
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end