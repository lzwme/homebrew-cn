class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https:github.comcloudwegokitex"
  url "https:github.comcloudwegokitexarchiverefstagsv0.13.0.tar.gz"
  sha256 "a86b275baa3c9ce96e36650203eb0beccc89136080f68773b189a6ed1e46c3e5"
  license "Apache-2.0"
  head "https:github.comcloudwegokitex.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f4a7896876bae337c884ea58b5384ce45d97067563390230b808365e0840709"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f4a7896876bae337c884ea58b5384ce45d97067563390230b808365e0840709"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f4a7896876bae337c884ea58b5384ce45d97067563390230b808365e0840709"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fd75ac2c0264237e9f4adeb32b60740fb0e772bafdf4a4db04e6125d608bb91"
    sha256 cellar: :any_skip_relocation, ventura:       "1fd75ac2c0264237e9f4adeb32b60740fb0e772bafdf4a4db04e6125d608bb91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d391f80d886027fb30cf2d7b8781365b533b80bfbe0bf8462716b5676edf6589"
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
    system bin"kitex", "-module", "test", "test.thrift"
    assert_path_exists testpath"go.mod"
    refute_predicate (testpath"go.mod").size, :zero?
    assert_path_exists testpath"kitex_gen""api""test.go"
    refute_predicate (testpath"kitex_gen""api""test.go").size, :zero?
  end
end