class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://ghproxy.com/https://github.com/cloudwego/kitex/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "92fe89e24c5268e1c850eb578b77230e154fa6ae6571fa7191282f80ef61e87f"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0596afba30fd63ea0726ed395fea5bd662f1b281937ceca0a5a81597d1790f65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c2390b43d1b22f835a5269b57e0b768c9f45710b5878c240877285fc179cb64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79be6b84ce4b00f7f5f83d2c2146454f4bde5c5f03e69bf6983983cf55c17ab0"
    sha256 cellar: :any_skip_relocation, sonoma:         "931820b68df3a14de6dbe548f30d4091a973d6859950d719009818146180e49d"
    sha256 cellar: :any_skip_relocation, ventura:        "dcb4c92cd0c0afa7c1f4e1ad7fb0d373bfcea302fc5d024b2e6214d6d411e9be"
    sha256 cellar: :any_skip_relocation, monterey:       "2b472e585c9c591a4470b2ee5180c93f68055bd407881f46c8aa16f3a6682d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b77d0e2f1d7ae14eb1bc4214d70c067cf813fbd538160a26832df03eb037b0c3"
  end

  depends_on "go" => [:build, :test]
  depends_on "thriftgo" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./tool/cmd/kitex"
  end

  test do
    output = shell_output("#{bin}/kitex --version 2>&1")
    assert_match "v#{version}", output

    thriftfile = testpath/"test.thrift"
    thriftfile.write <<~EOS
      namespace go api
      struct Request {
              1: string message
      }
      struct Response {
              1: string message
      }
      service Hello {
          Response echo(1: Request req)
      }
    EOS
    system "#{bin}/kitex", "-module", "test", "test.thrift"
    assert_predicate testpath/"go.mod", :exist?
    refute_predicate (testpath/"go.mod").size, :zero?
    assert_predicate testpath/"kitex_gen"/"api"/"test.go", :exist?
    refute_predicate (testpath/"kitex_gen"/"api"/"test.go").size, :zero?
  end
end