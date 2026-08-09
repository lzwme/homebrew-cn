class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.17.5.tar.gz"
  sha256 "910ba8e64d05fd48043f4c88492f32f459367be022ec08f0aa6e977c5c3419bf"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5d0a66b4813dc4bf987b128d9fa5ac04f7281195528c13b1003445dd52f6096"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5d0a66b4813dc4bf987b128d9fa5ac04f7281195528c13b1003445dd52f6096"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5d0a66b4813dc4bf987b128d9fa5ac04f7281195528c13b1003445dd52f6096"
    sha256 cellar: :any_skip_relocation, sonoma:        "e023849c98cadcaa686662b2c5237a477145e3b6fced013dc42396edbc5ed9b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b5c65d8359c187620f007e635904969444eb2682abaa454cbd2aa39965925b2"
    sha256 cellar: :any,                 x86_64_linux:  "83639fe47ce5a2a2b72386ab018e07e92ca2bb2f7269671877fc156455434697"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_match "Temporary Redirect", output
  end
end