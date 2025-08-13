class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://ghfast.top/https://github.com/mudler/LocalAI/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "a3393c91b777c93bfcbe04557e823a4d52dc130669e505c2dba2633db37adef0"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6deca014aa1fd1b0e0cd061da8f84baadc47bf5a022352556a479ed3143b41d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95ddbf84fd1f70d8d74bb5e09c8f3cb3668d778d3b450068c297c6c9bb519f9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f8e826651bd977d68c51f6a6caecb0bccec4c3689e2338ddce39a732a881e00"
    sha256 cellar: :any_skip_relocation, sonoma:        "617d2fa70ed913c951e83521143686ada51f9ec6e7832fc472ea9546ff2063bd"
    sha256 cellar: :any_skip_relocation, ventura:       "701ff0eb1026724704e7637cb6127641209e1c02bea137d15c7e70a06eba1234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6359b85d189ae70f7af2c19b63492e1385049d69e9efcb3fbd34108572869584"
  end

  depends_on "go" => :build
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

    spawn bin/"local-ai", "run", "--address", addr
    sleep 5
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    response = shell_output("curl -s -i #{addr}")
    assert_match "HTTP/1.1 200 OK", response
  end
end