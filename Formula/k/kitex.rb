class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https:github.comcloudwegokitex"
  url "https:github.comcloudwegokitexarchiverefstagsv0.10.2.tar.gz"
  sha256 "11a41247f0df99c8c752e8f7f2a7eb3a30fde09375352f8738fab01d8d436360"
  license "Apache-2.0"
  head "https:github.comcloudwegokitex.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0b1650e749c761772cb8dc6d5f0d90786d70935d3994438349a70dde71fc316"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90b3fbb6a6158d1decfdaaa1c4b2124df6b21a87d5103babd6e0e3a717e2ca5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e64640349c323bd264734e250ac00a7be444cef52b38702c8eea694249fc868b"
    sha256 cellar: :any_skip_relocation, sonoma:         "51cff861201b92aa566a94501b1c5b8aedfe57b2cccd62cf4ac87b67a3b26a31"
    sha256 cellar: :any_skip_relocation, ventura:        "78474c8f805b01676b639853fe4895e87e912063a3e2ad39307838d58d4506c0"
    sha256 cellar: :any_skip_relocation, monterey:       "4451cfd697750a7d89fcc4450d24066d5cf5eba63f346c5ca9fe172ced1e2947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f53f32a263029514ca6a5914e2b5b69fb94a988e384e3a7e3be76689d46f773"
  end

  depends_on "go" => [:build, :test]
  depends_on "thriftgo" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".toolcmdkitex"
  end

  test do
    output = shell_output("#{bin}kitex --version 2>&1")
    assert_match "v#{version}", output

    thriftfile = testpath"test.thrift"
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
    system "#{bin}kitex", "-module", "test", "test.thrift"
    assert_predicate testpath"go.mod", :exist?
    refute_predicate (testpath"go.mod").size, :zero?
    assert_predicate testpath"kitex_gen""api""test.go", :exist?
    refute_predicate (testpath"kitex_gen""api""test.go").size, :zero?
  end
end